class OverviewPresenter
  include Dtu::PresenterBehavior
  attr_reader :overview

  def initialize(exhibit, view_context)
    @exhibit = exhibit
    @view_context = view_context
    @overview = ExhibitOverview.find_by(exhibit: @exhibit)
  end

  def thumbnail
    url = @exhibit.thumbnail.present? ? @exhibit.thumbnail.image.square.url : 'spotlight/default_thumbnail.jpg'
    @view_context.image_tag(url)
  end

  def title
    @exhibit.title
  end

  def metadata
    data = {}
    ['research_area', 'institution', 'contact_details'].each do |var|
      data[var] = @overview.send(var)
    end
    data.select {|_,v| v.present? }
  end
end
