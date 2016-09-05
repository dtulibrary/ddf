class PagesController < ApplicationController
  include StatService

  def index
    @types = publications_by_facet('format_orig_s', limit: 50)
    @institutions = publications_by_facet('source_ss', limit: 50)
    @national_segments = OpenAccessIndicator.segment_attrs('national', OpenAccessIndicator::LAST_YEAR)
    @university_segments = OpenAccessIndicator.segment_attrs('universities', OpenAccessIndicator::LAST_YEAR)
  rescue OpenAccessIndicator::ServiceUnavailableException
    flash[:error] = "Open Access Indicator is temporarily unavailable."
    @national_segments = []
    @university_segments = []
  end

  # SEARCH
  def search
    render :layout => 'search'
  end

  # ELITEFORSK AWARD
  def eliteforsk_award
    render :layout => 'eliteforsk_award'
  end

  # ABOUT
  def about
    render :layout => 'about'
  end

  def search_and_get
    render :layout => 'about'
  end

  def data
    render :layout => 'about'
  end

  def data_providers
    render :layout => 'data_providers'
  end

  def faq
    render :layout => 'about'
  end

  def contact
    render :layout => 'about'
  end

  def releases
    render :layout => 'about'
  end

  def privacy
    render :layout => 'about'
  end

  # OTHER
  def pattern_library
    render :layout => 'chrome'
  end

  def feedback
    render :layout => 'chrome'
  end

  # ROBOTS
  def robots
    render :layout => nil
  end
end
