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
  def render_facet_link(facet)
    link_to facet[:label], catalog_index_path(:f => {facet[:name] => [facet[:code]]})
  end

  def render_facet_count(facet)
    num = number_with_delimiter(facet[:count])
    "<span class='count'>#{num}</span>".html_safe
  end

  def render_percentage_for(segment)
    pct = format_as_pct(segment[:pct])
    parenthesized = parenthesize_as_pct(segment[:pct])
    "<span class='pct' style='width: #{pct}'>#{parenthesized}</span>".html_safe
  end

  # Return the translated values for the open access resources
  def translate_oa_resources(resources)
    resources.collect do |k,v|
      [
        t("ddf.open_access.headers.#{k}"),
        v.collect { |opt| [t("ddf.open_access.labels.#{opt}"), opt] }
      ]
    end
  end

  def render_segment_link(segment)
    "<a href=''>#{segment[:label]}</a>".html_safe
  end

  def render_segment_count(segment)
    rounded = format_as_pct(segment[:pct].round(2))
    "<span class='count'>#{rounded}</span>".html_safe
  end

  def render_segment_percentage(segment)
    "<span class='pct' style='width: #{segment[:pct]}'>#{segment[:pct]}</span>".html_safe
  end
end
