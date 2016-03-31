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
        'format_orig_s'      => 'mxd_type_labels.publication_type_labels',
        'source_ss'          => 'mxd_type_labels.facet_source_labels',
        'review_status_s'    => 'mxd_type_labels.review_status_labels',
        'scientific_level_s' => 'mxd_type_labels.scientific_level_labels',
        'research_area_ss'   => 'custom_labels.research_area_labels',
        'access_condition_s' => 'mxd_type_labels.publishing_status_labels'
      }
  end
  # DataUtils


  class Plot
    # Generates data for a Chart JS plot chart (i.e. Bar or Line)
    include Charts::DataUtils

    attr_accessor :data

    def initialize(facet)
      @data = attrs_for(facet)
    end

    def values
      @data
    end

    def attrs_for(facet)
      hash = hashify(facet)
      {
        labels: ["1800", "1948", "1949", "1950", "1951", "1952", "1953", "1954", "1955", "1956", "1957", "1958", "1959", "1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"],
        datasets: [

          {
            label: "My First dataset",
            fillColor: "rgba(220,220,220,0.2)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: [10, 2, 6, 22, 18, 16, 16, 25, 28, 51, 52, 78, 82, 66, 81, 96, 137, 169, 217, 202, 251, 277, 300, 315, 407, 433, 538, 563, 597, 664, 775, 882, 1014, 1137, 1235, 1402, 1556, 1673, 1847, 2067, 2399, 2791, 3364, 4440, 7223, 8974, 9546, 12126, 12546, 14905, 18612, 19742, 25121, 25283, 29132, 31292, 32332, 34212, 35952, 39162, 40317, 45122, 46391, 47744, 49792, 50317, 50363, 51349, 50738, 10719, 80, 15, 1]
          }

        ]
      }
    end

    def labels_for(hash)
      hash.sort.map { |pair| pair.first }
    end

    def dataset_for(hash)
      h = {}
      h.store(:label, "My First dataset")
      h.store(:data, hash.sort.map { |pair| pair.last })
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

