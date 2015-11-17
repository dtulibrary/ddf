class OpenAccessIndicatorController < ApplicationController
  # A proxy method to get around CORS problems
  # TODO: refactor url into config file
  def get
    url = "http://devel.oai.cvt.dk/oa-indicator/ws/%{resource}.json/%{year}" %
        { year: params[:year], resource: params[:resource]}
    render json: Net::HTTP.get(URI(url))
  end
end