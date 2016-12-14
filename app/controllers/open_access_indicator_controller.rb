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
    tmp_file = nil
    # open-uri will either gives us a StringIO or a TempFile
    # depending on file size (I think)
    # In order to make sure that the methods are consistent,
    # we write to a TempFile before sending this.
    open(report_url) do |data|
      encoding = data.read.encoding
      data.rewind # need to move pointer back to start of buffer
      tmp_file = Tempfile.new(filename, encoding: encoding)
      tmp_file.write(data.read)
    end
    if tmp_file.present?
      send_file tmp_file, filename: filename, type: 'application/vnd.ms-excel'
    else
      redirect_to :back, status: 501, alert: 'Error getting report! Please contact us for support.'
    end
  rescue OpenURI::HTTPError # catch 404s and send back to the overview
    redirect_to :back, status: 307, alert: 'File not found!'
  end

  # This overwrites the default lookup view folder
  def self.controller_path
    'open_access'
  end
end
