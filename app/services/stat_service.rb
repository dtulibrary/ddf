#
# To create a new Chart JS chart, add the appropriate data to:
# 1) LABEL_TRANSLATIONS hash
# 2) CHARTJS_COLORS hash
# 3) Add the chart to javascripts/charts.js
#
module StatService

  def publications_by_facet(opts={}, &block)
    facet_list = yield
    limit = opts[:limit] || 1000 # arbitrary large value, or "no limit"
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

  # For charts that use no JS (ALA #256 Accessible Web Standards charts)
  def nojs_attrs_for(facet)
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

  # For charts that use Chart.js
  def chartjs_attrs_for(facet)
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
    t([LABEL_TRANSLATIONS[facet], '.', code].join)
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

  def relative_by(fn, value, numbers)
    res = FUNCTIONS[fn].call(numbers)
    value.to_f / res.to_f * 100
  end

  FUNCTIONS = {
    max:   ->(values) { values.max },
    total: ->(values) { values.reduce { |sum, val| sum += val } }
  }
end
