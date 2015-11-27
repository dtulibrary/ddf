module StatService

  def publications_by_facet(facet, opts={})
    facet_list = publication_attrs(facet)
    limit = opts[:limit] || limit_by_facet('source_ss')
    whitelist(facet_list).take(limit)
  end

  def raw_data_for(facet)
    publ = Blacklight.default_index.connection.get('ddf_publ',
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

  def values_for(facet)
    hashify(facet).values
  end

  def limit_by_facet(facet)
    hashify(facet).length
  end

  def publication_attrs(facet)
    a = []
    hashify(facet).each do |k, v|
      h = {}
      h.store(:name, facet)
      h.store(:code, k)
      h.store(:label, translate(facet, k))
      h.store(:count, v)
      h.store(:pct, relative_by(:max, v, facet))
      a << h
    end
    a
  end

  def whitelist(facet_list)
    facet_list.select { |hash| !BLACKLISTED_CODES.include? hash[:code] }
  end

  BLACKLISTED_CODES = ['do']

  def translate(facet, code)
    t([LABEL_TRANSLATIONS[facet], '.', code].join)
  end

  LABEL_TRANSLATIONS = {
    'format_orig_s' => 'mxd_type_labels.publication_type_labels',
    'source_ss'     => 'mxd_type_labels.source_labels'
  }

  def relative_by(fn, value, facet)
    counts = values_for(facet)
    res = FUNCTIONS[fn].call(counts)
    value.to_f / res.to_f * 100
  end

  FUNCTIONS = {
    max:   ->(values) { values.max },
    total: ->(values) { values.reduce { |sum, val| sum += val } }
  }
end
