module PagesHelper
  def format_as_pct(value)
    ["#{value}", "%"].join
  end

  def parenthesize_as_pct(value)
    ["(", format_as_pct(value), ")"].join
  end

  # Creates a link to a facet, like:
  # http://localhost:3000/en/catalog?f[format_orig_s][]=dja
  # Pattern:
  # link_to 'label', catalog_index_path(:f => {:format_orig_s => ['dja']})
  def render_link_to(facet)
    link_to facet[:label], catalog_index_path(:f => {facet[:name] => [facet[:code]]})
  end

  def render_count_for(facet)
    "<span class='count'>#{facet[:count]}</span>".html_safe
  end

  def render_percentage_for(facet)
    "<span class='pct' style='width: #{format_as_pct(facet[:pct])}'>#{parenthesize_as_pct(facet[:pct])}</span>".html_safe
  end
end
