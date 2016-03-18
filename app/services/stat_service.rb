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
    attrs = core_attrs_for(facet)
    attrs.map { |h| h.merge(chart_colors(h)) }
  end

  def core_attrs_for(facet)
    hash = hashify(facet)
    a = []
    hash.each do |k, v|
      h = {}
      h.store(:name, facet)
      h.store(:value, v)
      h.store(:label, translate(facet, k))
      a << h
    end
    a
  end

  def chart_colors(attrs)
    CHARTJS_COLORS[attrs[:name].to_sym][attrs[:label]]
  end

  CHARTJS_COLORS = {
    review_status_s: {
      'Undetermined' => { color: '#F15854', highlight: '#F15854' },
      'Peer Review' =>  { color: '#60BD68', highlight: '#60BD68' }
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
    'format_orig_s'   => 'mxd_type_labels.publication_type_labels',
    'source_ss'       => 'mxd_type_labels.facet_source_labels',
    'review_status_s' => 'mxd_type_labels.review_status_labels'
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
