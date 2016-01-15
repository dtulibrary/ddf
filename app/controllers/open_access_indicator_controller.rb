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
    year = params[:year] || '2016'
    view = params[:view] || 'relative'
    @overview = {}
    OpenAccessIndicator::RESOURCES.each do |resource|
      @overview[resource] = OpenAccessIndicator.fetch(resource, year, view)
    end
    render 'open_access/overview'
  end

  def development

    resource = params[:resource] || 'national'
  end
end
