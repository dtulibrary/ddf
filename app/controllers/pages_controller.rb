class PagesController < ApplicationController
  def index; end

  def data_providers
    render :layout => 'chrome'
  end

  def pattern_library
    render :layout => 'chrome'
  end
end
