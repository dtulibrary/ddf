#
# To create a new Chart JS chart, add the appropriate data to:
# 1) LABEL_TRANSLATIONS hash
# 2) CHARTJS_COLORS hash
# 3) Add the chart to javascripts/charts.js
#
module Charts
  module DataUtils
    include ActionView::Helpers::NumberHelper

    def publications_by_facet(opts={}, &block)
      facet_list = yield
      limit = opts[:limit] || 1000 # aribtrary large number, i.e "no limit"
      whitelist(facet_list).take(limit)
    end

    # (str) -> []
    def raw_data_for(facet)
      publ = Blacklight.solr.get('ddf_publ',
        :params => {
          :q => '*:*',
          :facet => 'true',
          'facet.field' => facet,
          :rows => 0 })
      publ['facet_counts']['facet_fields'][facet]
    end

    # (str) -> {}
    def hashify(facet)
      arr = raw_data_for(facet)
      Hash[*arr]
    end

    # (str, str) -> {}
    def set_colors_from(facet, code)
      CHARTJS_COLORS[facet.to_sym][code]
    end

    CHARTJS_COLORS = {
      review_status_s: {
        'undetermined' => { color: '#DECF3F', highlight: '#e2d455' }, # Yellow
        'peer_review' =>  { color: '#60BD68', highlight: '#72c479' }  # Green
        # TODO
        # 'other_review'
        # 'no_review'
      },

      scientific_level_s: {
        'scientific' =>   { color: '#5DA5DA', highlight: '#72b1df' }, # Blue
        'educational' =>  { color: '#F17CB0', highlight: '#f393be' }, # Pink
        'popular' =>      { color: '#FAA43A', highlight: '#fbaf53' }  # Orange
        # TODO
        # 'administrative'
        # 'undetermined'
      },

      research_area_ss: {
        'Humanities' =>         { color: '#F17CB0', highlight: '#f393be' }, # Pink
        'Medical science' =>    { color: '#F15854', highlight: '#f36f6c' }, # Orange
        'Science/technology' => { color: '#5DA5DA', highlight: '#72b1df' }, # Blue
        'Social science' =>     { color: '#DECF3F', highlight: '#e2d455' }  # Yellow
      },

      # Publication pipeline:
      # unknown > unpublished > submitted > accepted > in_press > published
        access_condition_s: {
          'published' =>   { color: '#5DA5DA', highlight: '#72b1df' }, # Blue
          'unknown' =>     { color: '#4D4D4D', highlight: '#5a5a5a' }, # Gray
          'submitted' =>   { color: '#F15854', highlight: '#f36f6c' }, # Orange
          'accepted' =>    { color: '#60BD68', highlight: '#72c479' }, # Green
          'in_press' =>    { color: '#DECF3F', highlight: '#e2d455' }, # Yellow
          'unpublished' => { color: '#F15854', highlight: '#f36f6c' }  # Red
        },

        pub_date_tsort: {
          fillColor:       "#60BD68",
          strokeColor:     "rgba(220,220,220, 1)", # chart outer border
          highlightFill:   "rgba(220,220,220,0.75)", # ?
          highlightStroke: "rgba(220,220,220,1)" # ?
        },

        submission_year_tis: {
          fillColor:       "#DECF3F",
          strokeColor:     "rgba(220,220,220, 1)", # chart outer border
          highlightFill:   "rgba(220,220,220,0.75)", # ?
          highlightStroke: "rgba(220,220,220,1)" # ?
        }
      }

      # ([{}..]) -> [{}..]
      def whitelist(facet_segments)
        facet = facet_segments.first[:name]
        if !BLACKLISTED_CODES.has_key? facet
          facet_segments
        else
          bad_codes = BLACKLISTED_CODES[facet]
          facet_segments.select { |seg| !bad_codes.include? seg[:code] }
        end
      end

      BLACKLISTED_CODES = {
        'format_orig_s'       => ['do'],
        'isolanguage_ss'      => ['und', 'mul'],
        'journal_title_facet' => ['Ikke Angivet']
      }

      METADATA_FACETS = ['journal_title_facet', 'author_facet']

      # (str, str) -> str
      def translate(facet, code)
        if METADATA_FACETS.include? facet
          code
        else
          I18n.t([LABEL_TRANSLATIONS[facet], '.', code].join)
        end
      end

      # These look up config/locales/[da|en].yml
      LABEL_TRANSLATIONS = {
        'format_orig_s'       => 'mxd_type_labels.publication_type_labels',
        'source_ss'           => 'mxd_type_labels.facet_source_labels',
        'review_status_s'     => 'mxd_type_labels.review_status_labels',
        'scientific_level_s'  => 'mxd_type_labels.scientific_level_labels',
        'research_area_ss'    => 'custom_labels.research_area_labels',
        'access_condition_s'  => 'mxd_type_labels.publishing_status_labels',
        'pub_date_tsort'      => 'blacklight.search.fields.facet',
        'submission_year_tis' => 'blacklight.search.fields.facet',
        'isolanguage_ss'      => 'mxd_type_labels.language_labels'
      }
  end
  # DataUtils


  class Plot
    # Generates data for a Chart JS plot chart (i.e. Bar or Line)
    include Charts::DataUtils

    attr_accessor :facets, :data_ranges

    # 1) Map facets to data sets
    # 2) Extract x values (years) from 1)
    # 3) For each dataset:
      # A) Extract y values (counts) from 1)
      # B) Map facets to labels
      # C) Map facets to colors
      # D) Combine A, B, and C
    # 4) Combine 2 and D

    # ([str..], *[{}..]) -> [{}..]
    def initialize(facets, data_ranges=[])
      @facets = facets
      if data_ranges.empty? # generate data ranges from facet list
        ranges = facets.map { |facet| hashify(facet) } # [{}, {}, ... , {}]
        # Invarant: all functions operate on this sorted range:
        @data_ranges = ranges.map { |hash| Hash[*hash.sort.flatten] }
      else
        @data_ranges = data_ranges
      end
    end

    # () -> {}
    def values()
      json_structure
    end

    #
    # If currying, could do smth like:
    # l = method(:from).to_proc
    # l.call(1971)
    #
    # (int) -> Plot.new
    def from(year)
      new_ranges = @data_ranges.map do |range|
        pairs = range.sort
        selection = pairs.select { |pair| pair.first.to_i >= year }
        Hash[*selection.flatten]
      end
      self.class.new(self.facets, new_ranges)
    end

    # not very dry, shares structure with from(year)
    # (int) -> Plot.new
    def to(year)
      new_ranges = @data_ranges.map do |range|
        pairs = range.sort
        selection = pairs.select { |pair| pair.first.to_i <= year }
        Hash[*selection.flatten]
      end
      self.class.new(self.facets, new_ranges)
    end

    # (int) -> Plot.new
    def interval(step)
      new_ranges = @data_ranges.map do |range|
        intervals = range.each_slice(step).to_a
        reduced = intervals.map { |interval| reduce_interval(interval) }
        Hash[*reduced.flatten]
      end
      self.class.new(self.facets, new_ranges)
    end

    # ([]) -> []
    def reduce_interval(arr)
      years = arr.map { |pair| pair.first }.flatten
      counts = arr.map { |pair| pair.last }.flatten
      year_range = if years.first.eql? years.last
        years.first
      else
        [years.first, years.last].join("-")
      end
      total_count = counts.reduce { |sum, count| sum += count }
      [year_range, total_count]
    end

    # () -> {}
    def datasets
      y_values = data_ranges.map { |hash| y_range(hash) }
      complete_values = y_values.zip(labels, colors)
      combined_values = complete_values.map { |arr| arr.reduce({}) { |acc, hash| acc.merge hash } }
      { datasets: combined_values }
    end

    # () -> {}
    def x_range
      { labels: data_ranges.first.keys }
    end

    # ({}) -> {}
    def y_range(data_range)
      { data: data_range.values }
    end

    # () -> {}
    def colors
      @facets.map { |label| CHARTJS_COLORS[label.to_sym] }
    end

    # () -> {}
    def labels
      @facets.map { |facet| { label: translate(facet, facet) } }
    end

    # () -> {}
    def json_structure
      x_range.merge datasets
    end
  end
  # Plot

  class Segments
    # Generates data for a Chart JS segmented chart (i.e. Pie or Donut)
    include Charts::DataUtils

    attr_accessor :data

    def values(opts={})
      limit = opts[:limit] || 1000 # aribtrary large number, i.e "no limit"
      whitelist(data).take(limit)
    end

    def initialize(facet)
      @data = attrs_for(facet)
    end

    def attrs_for(facet)
      hash = hashify(facet)
      a = []
      hash.each do |k, v|
        h = {}
        # h.store(:name, facet)
        h.store(:segment, k)
        h.store(:label, translate(facet, k))
        h.store(:value, v)
        a << h.merge(set_colors_from(facet, k))
      end
      a
    end
  end
  # Segments


  class CSSBars
    include Charts::DataUtils

    attr_accessor :data

    def values(opts={})
      limit = opts[:limit] || 1000 # aribtrary large number, i.e "no limit"
      whitelist(data).take(limit)
    end

    def initialize(facet)
      @data = attrs_for(facet)
    end

    def attrs_for(facet)
      hash = hashify(facet)
      counts = hash.values
      a = []
      hash.each do |k, v|
        h = {}
        h.store(:name, facet)
        h.store(:code, k)
        h.store(:label, translate(facet, k))
        h.store(:count, v)
        h.store(:pct, relative_by(:max, v, counts))
        a << h
      end
      a
    end

    def relative_by(fn, value, numbers)
      res = FUNCTIONS[fn].call(numbers)
      value.to_f / res.to_f * 100
    end

    FUNCTIONS = {
      max:   ->(values) { values.max },
      total: ->(values) { values.reduce { |sum, val| sum += val } }
    }
  end
  # CSSBars
end
# Charts

