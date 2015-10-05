module StatService

  def publications_by_facet(facet, limit: 10)
    publication_attrs(to_hash(raw_data_for(facet)), facet).take(limit)
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

  def to_hash(arr)
    Hash[*arr]
  end

  def values_for(facet)
    to_hash(raw_data_for(facet)).values
  end

  def publication_attrs(hash, facet)
    a = []
    hash.each do |k, v|
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
