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
            "<i class='ai ai-open-access ai-3x'></i>",
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

            def statistics_item_contents
              [
                "<i class='fa fa-bar-chart'></i>",
                "<span class='menu-item-title'>",
                "#{t('blacklight.navigation.statistics_section.statistics')}",
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

  def render_submenu
    if controller_name == 'open_access_indicator'
      render partial: 'shared/open_access'
    else
      render partial: 'shared/search'
    end
  end

  def render_feedback_button
    if controller_name.eql? 'open_access_indicator'
      render partial: 'shared/feedback_oa'
    elsif !(controller_name.eql?('pages') && action_name.eql?('index'))
      render partial: 'shared/feedback_general'
    end
  end
end
