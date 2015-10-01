module PagesHelper
  def format_as_pct(value)
    ["#{value}", "%"].join
  end

  def parenthesize_as_pct(value)
    ["(", format_as_pct(value), ")"].join
  end

  def link_to_facet(facet)
    # binding.pry
    # http://localhost:3000/en/catalog?f[format_orig_s][]=dja
    # http://localhost:3000/en/catalog?f[source_ss][]=rdb_ku
    link_to facet[:label], catalog_index_path(:f => {facet[:name] => [facet[:code]]})
  end
end
