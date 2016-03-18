class StatisticsController < ApplicationController
  include StatService
  layout "statistics"

  def index
    @types = publications_by_facet { nojs_attrs_for('format_orig_s') }
    @institutions = publications_by_facet { nojs_attrs_for('source_ss') }
    @review = publications_by_facet { chartjs_attrs_for('review_status_s') }.to_json
  end
end
