module SpotlightHelper
  include Spotlight::MainAppHelpers

  def should_render_spotlight_search_bar?
    false
  end

  def within_spotlight?
    controller.class.to_s.include? 'Spotlight'
  end

  ##
  # Overrides default Blacklight behaviour to disable
  # Search bar on Spotlight pages.
  # Render the search navbar
  # @return [String]
  def render_search_bar
    render :partial=>'catalog/search_form' unless within_spotlight?
  end
end
