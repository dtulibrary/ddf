class StatisticsController < ApplicationController
  include Charts
  layout "statistics"

  def index
    # Chart JS doughnut / pie
    @by_review_type = Charts::Segments.new('review_status_s').values.to_json
    @by_sci_level = Charts::Segments.new('scientific_level_s').values.to_json
    @by_research_area = Charts::Segments.new('research_area_ss').values.to_json
    @by_publication_status = Charts::Segments.new('access_condition_s').values.to_json

    # Chart JS bar / line
    facets = ['pub_date_tsort', 'submission_year_tis']
    @by_year = Charts::Plot.new(facets).from(1960).interval(5).values.to_json
    # @by_year = Charts::Plot.new(facets).from(2000).interval(5).values.to_json

    # No JS charts
    @by_type = Charts::CSSBars.new('format_orig_s').values
    @by_institution = Charts::CSSBars.new('source_ss').values
  end
end
