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
    @year = params[:year] || OpenAccessIndicator.available_years.last
    @view = params[:view] || 'relative'
    @overview = {}
    OpenAccessIndicator::RESOURCES.keys.each do |resource|
      @overview[resource] = OpenAccessIndicator.fetch(resource, @year, @view)
    end
  rescue OpenAccessIndicator::ServiceUnavailableException
    render 'error', status: 502
  end

  def development
    @key = params[:key] || 'national'
    # get the resource that corresponds to this key
    @resource = OpenAccessIndicator::RESOURCES.select {|k,v| @key.in? v}.keys.first
    @timeline = OpenAccessIndicator.timeline(@resource, @key) #used only once
    @years = OpenAccessIndicator::TOTAL_YEARS
  rescue OpenAccessIndicator::ServiceUnavailableException
    render 'error', status: 502
  end

  def reports
    report_url = OpenAccessIndicator.report_url(
      params[:year], params[:lang], params[:report]
    )
    filename = OpenAccessIndicator.report_name(
      params[:year], params[:lang], params[:report]
    )
    report = open(report_url)
    send_file report, filename: filename, type: 'application/vnd.ms-excel'
  rescue # catch 404s and send back to the overview
    redirect_to open_access_overview_path, alert: 'File not found!'
  end

  # This overwrites the default lookup view folder
  def self.controller_path
    'open_access'
  end
end
