module StatService

  def publications_by_facet(facet, limit: 60)
    facet_list = publication_attrs(to_hash(facet), facet)
    whitelist(facet_list).take(display_limit)
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

  def to_hash(facet)
    arr = raw_data_for(facet)
    Hash[*arr]
  end

  def values_for(facet)
    to_hash(facet).values
  end

  def display_limit
    to_hash('source_ss').length
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

  def whitelist(facet_list)
    facet_list.select { |hash| (hash.values & BLACKLISTED_LABELS).empty? }
  end

  BLACKLISTED_LABELS = ['Other']

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
