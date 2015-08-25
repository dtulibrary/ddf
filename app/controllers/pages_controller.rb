class PagesController < ApplicationController
  def index; end

  # SEARCH
  def search
    render :layout => 'search'
  end

  def tutorial
    render :layout => 'search'
  end

  def faq
    render :layout => 'search'
  end

  # ABOUT
  def about
    render :layout => 'about'
  end

  def data_formats
    render :layout => 'about'
  end

  def data_providers
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
