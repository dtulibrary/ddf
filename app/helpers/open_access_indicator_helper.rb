module OpenAccessIndicatorHelper
  def render_oa_unit_heading(unit)
    if unit.eql? "national"
      "<h3 class='oa-label oa-label--total'>#{t("ddf.open_access.labels.#{unit}")}</h3>".html_safe
    else
      "<h3 class='oa-label'>#{t("ddf.open_access.labels.#{unit}")}</h3>".html_safe
    end
  end

  def render_label_for(year)
    "<span class='label'>#{year}</span>".html_safe
  end

  def render_pct_for(resource, key, year)
    pct = OpenAccessIndicator.get_percentage_for(resource, key, year)
    rounded = pct.round(2)
    "<span class='count' style='height: #{pct}%'>#{rounded}%</span>".html_safe
  end

  def render_overview_link_for(year)
    [open_access_overview_path, "?year=#{year}"].join
  end
end



