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
    OpenAccessIndicator::RESOURCES.each do |resource|
      @overview[resource] = OpenAccessIndicator.fetch(resource, year, view)
    end
  end

  def development
    resource = params[:resource] || 'national'
    key = params[:key] || 'national'
    @timeline = OpenAccessIndicator.timeline(resource, key)
  end

  # This overwrites the default lookup view folder
  def self.controller_path
    'open_access'
  end
end
