module PagesHelper
  def format_as_pct(value)
    ["#{value}", "%"].join
  end

  def parenthesize_as_pct(value)
    ["(", format_as_pct(value), ")"].join
  end

  def link_to_facet(facet)
    link_to facet[:label], catalog_index_path(:f => {:format_orig_s => [facet[:code]]})
  end
end
