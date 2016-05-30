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
    two_years_ahead = DateTime.now.year + 2
    @by_publication_year = Charts::Plot.new(['pub_date_tsort']).from(1955).to(two_years_ahead).interval(5).values.to_json
    @by_submission_year  = Charts::Plot.new(['submission_year_tis']).from(1955).to(two_years_ahead).interval(5).values.to_json

    # No JS charts
    @by_type = Charts::CSSBars.new('format_orig_s').values
    @by_language = Charts::CSSBars.new('isolanguage_ss').values(limit: 13)
    @by_institution = Charts::CSSBars.new('source_ss').values
    @by_journal_title = Charts::CSSBars.new('journal_title_facet').values(limit: 13)
    @by_author = Charts::CSSBars.new('author_facet').values(limit: 13)

    render :layout => 'search_static'
  end
end
