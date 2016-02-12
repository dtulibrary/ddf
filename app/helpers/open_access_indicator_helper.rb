module OpenAccessIndicatorHelper
  def format_as_pct(value)
    ["#{value}", "%"].join
  end

  def parenthesize_as_pct(value)
    ["(", format_as_pct(value), ")"].join
  end

  # TODO for OA years
  # Creates a link to a facet, like:
  # http://localhost:3000/en/catalog?f[format_orig_s][]=dja
  # Pattern:
  # link_to 'label', catalog_index_path(:f => {:format_orig_s => ['dja']})
  # def render_link_to(facet)
  #   link_to facet[:label], catalog_index_path(:f => {facet[:name] => [facet[:code]]})
  # end

  # def render_count_for(facet)
  #   num = number_with_delimiter(facet[:count])
  #   "<span class='count'>#{num}</span>".html_safe
  # end

  # def render_percentage_for(facet)
  #   pct = format_as_pct(facet[:pct])
  #   parenthesized = parenthesize_as_pct(facet[:pct])
  #   "<span class='pct' style='width: #{pct}'>#{parenthesized}</span>".html_safe
  # end

  def render_pct_for(key, year)
    pct = OpenAccessIndicator.get_percentage_for(key, year)
    "<span class='count' style='height: #{pct}'>#{pct}</span>".html_safe
  end

end
