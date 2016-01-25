class OpenAccessIndicatorController < ApplicationController

  def chart
    @stats = OpenAccessIndicator.fetch(params[:resource], params[:year])
    if @stats.present?
      render 'open_access/chart', layout: nil
    else
      render text: 'error', status: :unprocessable_entity
    end
  end

  def overview
    year = params[:year] || OpenAccessIndicator::YEARS.first
    view = params[:view] || 'relative'
    @overview = {}
    OpenAccessIndicator::RESOURCES.keys.each do |resource|
      @overview[resource] = OpenAccessIndicator.fetch(resource, year, view)
    end
  end

  def development
    @key = params[:key] || 'national'
    # get the resource that corresponds to this key
    @resource = OpenAccessIndicator::RESOURCES.select {|k,v| @key.in? v}.keys.first
    @timeline = OpenAccessIndicator.timeline(@resource, @key)
  end

  # This overwrites the default lookup view folder
  def self.controller_path
    'open_access'
  end
end
