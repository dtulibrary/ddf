class ExhibitOverviewsController < Spotlight::ApplicationController
  before_action :authenticate_user!
  before_action :set_exhibit, only: [:edit]

  def edit
    @overview = ExhibitOverview.find_by(exhibit: @exhibit) || ExhibitOverview.new(exhibit: @exhibit)
  end

  def create
    @exhibit = Spotlight::Exhibit.find(overview_params[:exhibit_id])
    @overview = ExhibitOverview.new(overview_params)
    if @overview.save
      redirect_to spotlight.exhibit_dashboard_path(@exhibit), notice: 'Overview created'
    else
      redirect_to spotlight.exhibit_dashboard_path(@exhibit), notice: 'Overview could not be created'
    end
  end

  def update
    @exhibit = Spotlight::Exhibit.find(overview_params[:exhibit_id])
    @overview = ExhibitOverview.find_by(exhibit: @exhibit)
    if @overview.update(overview_params)
      redirect_to spotlight.exhibit_dashboard_path(@exhibit), notice: 'Overview updated'
    else
      redirect_to spotlight.exhibit_dashboard_path(@exhibit), notice: 'Overview could not be updated'
    end
  end

  def set_exhibit
    @exhibit = Spotlight::Exhibit.find(params[:id])
  end

  def overview_params
    params.require(:exhibit_overview).permit(:institution, :research_area, :contact_details, :exhibit_id)
  end
end
