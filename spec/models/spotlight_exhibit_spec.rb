describe Spotlight::Exhibit do
  describe 'monkeypatched' do
    subject { described_class.new.patched? }
    it { should eql true }
  end
  describe 'default scopes' do
    described_class { should respond_to :published }
  end

  describe 'has many overviews' do
    let(:exhibit) { Spotlight::Exhibit.create(title: 'bla', slug: 'bla') }
    let(:overview) { ExhibitOverview.create(exhibit: exhibit) }
    it 'should be deleted when its exhibit is deleted' do
      expect(overview).to be_valid
      expect { exhibit.destroy }.to change { ExhibitOverview.count }.by(-1)
    end
  end
end