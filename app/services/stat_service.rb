module StatService

  def publications_by_facet(facet)
    publication_attrs(to_hash(facet_values(facet)), facet)
  end

  def facet_values(facet)
    publ = Blacklight.solr.get('ddf_publ',
      :params => {
        :q => '*:*',
        :facet => 'true',
        'facet.field' => facet,
        :rows => 0 })
    publ['facet_counts']['facet_fields'][facet]
  end

  def to_hash(arr)
    types_abbr = Hash[*arr]
  end

  def values_for(facet)
    to_hash(facet_values(facet)).values
  end

  def publication_attrs(hash, facet)
    a = []
    hash.each do |k, v|
      h = {}
      h.store(:code, k)
      h.store(:label, t("mxd_type_labels.publication_type_labels.#{k}"))
      h.store(:count, v)
      h.store(:pct, relative_by(:max, v, facet))
      a << h
    end
    a
  end

  # def relative_by_max(value, facet)
  #   max = max_count_for(facet)
  #   value.to_f / max.to_f * 100
  # end

  # def relative_by_total(value, facet)
  #   total = total_count_for(facet)
  #   value.to_f / total.to_f * 100
  # end

  # def max_count_for(facet)
  #   to_hash(facet_values(facet)).values.max
  # end

  # def total_count_for(facet)
  #   to_hash(facet_values(facet)).values.reduce { |sum, val| sum += val }
  # end

  def relative_by(fn, value, facet)
    # binding.pry
    counts = values_for(facet)
    res = FUNCTIONS[fn].call(counts)
    value.to_f / res.to_f * 100
  end

  FUNCTIONS = {
    max:   ->(values) { values.max },
    total: ->(values) { values.reduce { |sum, val| sum += val } }
  }


# current:
# { "Journal article" => 369463 }
#
# desired:
# { :code=>"dja", :label=>"Journal article", :count=>369463, :pct=>42 }

end
