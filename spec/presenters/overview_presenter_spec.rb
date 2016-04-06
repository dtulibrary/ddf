require 'rails_helper'

describe OverviewPresenter, type: :view do
  it 'is initialized with an exhibit' do
    expect {
      OverviewPresenter.new(Spotlight::Exhibit.new, view)
    }.not_to raise_error
  end
  before do
    @exhibit = Spotlight::Exhibit.create!(title: 'Clever Researcher')
    @overview = ExhibitOverview.create!(institution: 'KU', exhibit: @exhibit)
    @presenter = OverviewPresenter.new(@exhibit, view)
  end
  after do
    ExhibitOverview.delete_all
    Spotlight::Exhibit.delete_all
  end
  it 'finds the overview' do
    expect(@presenter.overview).to eql @overview
  end

  it 'returns the exhibition thumbnail' do
    @exhibit.stub_chain(:thumbnail, :image, :square, :url).and_return('test.jpg')
    expect(@presenter.thumbnail).to include '<img src='
    expect(@presenter.thumbnail).to include 'test'
  end

  it 'returns the exhibition title' do
    expect(@presenter.title).to eql 'Clever Researcher'
  end

  it 'returns a hash of overview metadata' do
    expect(@presenter.metadata).to be_a Hash
    expect(@presenter.metadata['institution']).to eql 'KU'
  end

  it 'contains no empty values' do
    expect(@presenter.metadata.values).not_to include nil
  end
end
