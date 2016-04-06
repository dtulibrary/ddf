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

  # Utilities for displaying search history
  def previous_searches
    searches_from_history.select { |search| real? search }
  end

  def real?(search)
    search.query_params.has_key?('q') ||
    search.query_params.has_key?('f')
  end

  def latest_search_path
    if has_search_history?
      search_action_path(previous_searches.first.query_params)
    else
      ""
    end
  end

  def has_search_history?
    !previous_searches.empty?
  end

  # Copied from app/controllers/concerns/blacklight/controller.rb
  def searches_from_history
    session[:history].blank? ? Search.none : Search.where(:id => session[:history]).order("updated_at desc")
  end

  def render_locale_switcher(*locales)
    return if within_spotlight?
    if I18n.locale.eql? locales[0]
      link_to t('blacklight.language_switcher'), request.params.except(:locale).merge(:locale => locales[1])
    else
      link_to t('blacklight.language_switcher'), request.params.except(:locale).merge(:locale => locales[0])
    end
  end
end
