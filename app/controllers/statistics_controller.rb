class StatisticsController < ApplicationController
  include StatService
  layout "statistics"

  def index
    # No JS charts
    @types = publications_by_facet { nojs_attrs_for('format_orig_s') }
    @institutions = publications_by_facet { nojs_attrs_for('source_ss') }

    # JS charts
    @review = publications_by_facet { chartjs_attrs_for('review_status_s') }.to_json
    @sci_level = publications_by_facet { chartjs_attrs_for('scientific_level_s') }.to_json
    # @res_area = publications_by_facet { chartjs_attrs_for('research_area_ss') }.to_json
  end
end
