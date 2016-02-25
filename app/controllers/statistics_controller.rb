class StatisticsController < ApplicationController
  include StatService
  layout "statistics"

  def index
    @types = publications_by_facet('format_orig_s', limit: 50)
    @institutions = publications_by_facet('source_ss', limit: 50)
  end
end
