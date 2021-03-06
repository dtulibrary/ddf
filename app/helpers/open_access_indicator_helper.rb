module OpenAccessIndicatorHelper
  def render_oa_unit_heading(unit)
    if unit.eql? "national"
      "<h3 class='oa-label oa-label--total'>#{t("ddf.open_access.labels.#{unit}")}</h3>".html_safe
    else
      "<h3 class='oa-label'>#{t("ddf.open_access.labels.#{unit}")}</h3>".html_safe
    end
  end

  def render_label_for(year)
    "<time datetime='#{year}' class='label'>#{year}</time>".html_safe
  end

  def render_pct_for(value)
    int = value.to_i
    float = value.to_f
    rounded = (float % 10)==0? float.round(0) : float.round(2)
    "<span class='count' style='height: #{rounded}%'>#{int}%</span>".html_safe
  end

  def render_realized_pct_for(value)
    int = value.to_i
    float = value.to_f
    rounded = float.round(2)
    "<span class='count' style='height: #{rounded}%'>
      #{int}%
      <span class='decimals'>#{rounded}%</span>
    </span>".html_safe
  end

  def render_decimals_for(value)
    float = value.to_f
    rounded = (float % 10)==0? float.round(0) : float.round(2)
    "<span class='decimals'>#{rounded}%</span>".html_safe
  end

  def render_overview_link_for(year)
    [open_access_overview_path, "?year=#{year}"].join
  end

  def render_bar_for(resource, key, year)
    if OpenAccessIndicator.available? year
      render_available(resource, key, year)
    elsif OpenAccessIndicator.projected? year
      render_projected(year)
    else
      render_unavailable(year)
    end
  end

  def render_available(resource, key, year)
    percentage = OpenAccessIndicator.get_percentage_for(resource, key, year)
    "<li class='available'>
      <a href='#{render_overview_link_for(year)}'>
        #{render_label_for(year)}
        #{render_realized_pct_for(percentage)}
      </a>
    </li>".html_safe
  end

  def render_unavailable(year)
    "<li id='#{year}' class='unavailable'>
      <a>
        #{render_label_for(year)}
        #{render_pct_for(0)}
      </a>
    </li>".html_safe
  end

  def render_projected(year)
    percentage = OpenAccessIndicator::PROJECTED_YEARS[year]
    "<li id='#{year}' class='projected'>
      <a>
        #{render_label_for(year)}
        #{render_pct_for(percentage)}
      </a>
    </li>".html_safe
  end

  def render_overview_doc_link(year)
    doc_url = "/oa-docs/overview/Open_Access_Indicator_#{year}_Overview_#{I18n.locale}.pdf"
    "<a href='#{doc_url}'>#{t('ddf.open_access.legend.overview.description.overview')}</a>".html_safe
  end

  def render_technical_doc_link(year)
    doc_url =  "/oa-docs/technical/Open_Access_Indicator_#{year}_Technical_#{I18n.locale}.pdf"
    "<a href='#{doc_url}'>#{t('ddf.open_access.legend.overview.description.technical')}</a>".html_safe
  end

  def render_fi_link
    link_to(t('ddf.open_access.legend.overview.description.at_fi'), "http://ufm.dk/forskning-og-innovation/samspil-mellem-viden-og-innovation/open-access/artikler/status")
  end
end
