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
    @pub_year = Charts::Plot.new('pub_date_tsort').values(from: 1950, to: 2019, interval: 5).to_json
  end
end
