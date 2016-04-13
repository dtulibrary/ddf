class StatisticsController < ApplicationController
  include Charts
  layout "statistics"

  def index
    # No JS charts
    @types = Charts::CSSBars.new('format_orig_s').values
    @institutions = Charts::CSSBars.new('source_ss').values

    # Chart JS doughnut / pie
    @review = Charts::Segments.new('review_status_s').values.to_json
    @sci_level = Charts::Segments.new('scientific_level_s').values.to_json
    @res_area = Charts::Segments.new('research_area_ss').values.to_json
    @pub_status = Charts::Segments.new('access_condition_s').values.to_json

    # Chart JS bar / line
    facets = ['pub_date_tsort', 'submission_year_tis']
    @pub_year = Charts::Plot.new(facets).from(1950).interval(5).values.to_json
  end
end
