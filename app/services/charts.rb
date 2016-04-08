#
# To create a new Chart JS chart, add the appropriate data to:
# 1) LABEL_TRANSLATIONS hash
# 2) CHARTJS_COLORS hash
# 3) Add the chart to javascripts/charts.js
#
module Charts
  module DataUtils
    def publications_by_facet(opts={}, &block)
      facet_list = yield
      limit = opts[:limit] || 1000 # aribtrary large number, i.e "no limit"
      whitelist(facet_list).take(limit)
    end

    def raw_data_for(facet)
      publ = Blacklight.solr.get('ddf_publ',
        :params => {
          :q => '*:*',
          :facet => 'true',
          'facet.field' => facet,
          :rows => 0 })
      publ['facet_counts']['facet_fields'][facet]
    end

    def hashify(facet)
      arr = raw_data_for(facet)
      Hash[*arr]
    end

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
          fillColor: "rgba(220,220,220,0.5)",
          strokeColor: "rgba(220,220,220,0.8)",
          highlightFill: "rgba(220,220,220,0.75)",
          highlightStroke: "rgba(220,220,220,1)"
        },

        submission_year_tis: {
          fillColor: "rgba(220,220,220,0.5)",
          strokeColor: "rgba(220,220,220,0.8)",
          highlightFill: "rgba(220,220,220,0.75)",
          highlightStroke: "rgba(220,220,220,1)"
        }
      }

      def whitelist(facet_list)
        facet_list.select { |hash| !BLACKLISTED_CODES.include? hash[:code] }
      end

      BLACKLISTED_CODES = ['do']

      def translate(facet, code)
        I18n.t([LABEL_TRANSLATIONS[facet], '.', code].join)
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
        'submission_year_tis' => 'blacklight.search.fields.facet'
      }
  end
  # DataUtils


  class Plot
    # Generates data for a Chart JS plot chart (i.e. Bar or Line)
    include Charts::DataUtils

    attr_accessor :data_ranges

    # 1) Map facets to data sets
    # 2) Extract x values (years) from 1)
    # 3) For each dataset:
      # A) Extract y values (counts) from 1)
      # B) Map facets to labels
      # C) Map facets to colors
      # D) Combine A, B, and C
    # 4) Combine 2 and D

    def initialize(facets, opts={})
      @facets = facets
      @data_ranges = facets.map { |facet| hashify(facet) } # [{}, {}, ... , {}]

      # Invariant: @facets.map generates an array whose order corresponds
      # to the order of elements in @facets.
      # Therefore: @facets[i] maps to @data_ranges[i] for all i in [0 < i < @facets.length]
      # Therefore: zipping is guaranteed to preserve that mapping.

      # associate labels with hashes
      @facets.zip(@data_ranges).to_h
    end

    def values(opts={})
      # options = { from: x_values.first.to_i, to: x_values.last.to_i }
      # options = options.merge opts
      @data = json_structure
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
      { labels: data_ranges.first.sort.map { |pair| pair.first } }
    end

    # {} -> {}
    def y_range(data_range)
      { data: data_range.sort.map { |pair| pair.last } }
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

    # TODO
    def configure_data_range(range, opts)
      year_range = range.select do |pair|
        (pair.first.to_i >= opts[:from]) &&
        (pair.first.to_i <= opts[:to])
      end

      # binding.pry

      if opts[:interval]
        year_intervals = year_range.each_slice(opts[:interval]).to_a
        reduce_intervals(year_intervals)
      else
        year_range
      end
    end

    def reduce_intervals(arr)
      arr.map { |interval| reduce_interval(interval) }
    end

    # reduce y-range, rather
    def reduce_interval(arr)
      years = extract_x_range(arr).flatten
      counts = extract_y_range(arr).flatten
      year_range = if years.first.eql? years.last
        years.first
      else
        [years.first, years.last].join("-")
      end
      total_count = counts.reduce { |sum, count| sum += count }
      [year_range, total_count]
    end

    def extract_x_range(arr)
      arr.map { |pair| pair.first }
    end

    def extract_y_range(arr)
      arr.map { |pair| pair.last }
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
        h.store(:name, facet)
        h.store(:value, v)
        h.store(:label, translate(facet, k))
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

