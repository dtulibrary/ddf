class PagesController < ApplicationController
  def index; end

  # def data
  #   respond_to do |format|
  #     format.json { render :json => [1, 2, 3, 4, 5] }
  #   end
  # end

  # SEARCH
  def search
    render :layout => 'search'
  end

  # OPEN ACCESS
  def open_access
    render :layout => 'open_access'
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

  def faq
    render :layout => 'about'
  end

  def contact
    render :layout => 'about'
  end

  # OTHER
  def pattern_library
    render :layout => 'chrome'
  end
end
