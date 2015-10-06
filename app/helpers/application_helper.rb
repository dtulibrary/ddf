module ApplicationHelper
  def home_item_contents
    [
      "<em>#{t('blacklight.national')}</em>",
      "#{t('blacklight.research_database')}"
    ].join.html_safe
  end

  def search_item_contents
    [
      "<i class='glyphicon glyphicon-search'></i>",
      "<span class='menu-item-title'>",
        "#{t('blacklight.navigation.search_section.search')}",
      "</span>"
    ].join.html_safe
  end

  def about_item_contents
      [
        "<i class='glyphicon glyphicon-info-sign'></i>",
        "<span class='menu-item-title'>",
          "#{t('blacklight.navigation.about_section.about')}",
        "</span>"
      ].join.html_safe
  end

  def open_access_item_contents
    [
      "<i class='glyphicon glyphicon-lock'></i>",
      "<span class='menu-item-title'>",
        "#{t('blacklight.navigation.oa_section.open_access')}",
      "</span>"
    ].join.html_safe
  end

  def eliteforsk_award_item_contents
    [
      "<i class='glyphicon glyphicon-education'></i>",
      "<span class='menu-item-title'>",
        "#{t('blacklight.navigation.ef_section.eliteforsk')}",
      "</span>"
    ].join.html_safe
  end
end
