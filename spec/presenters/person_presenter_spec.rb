describe PersonPresenter do
  let(:source_doc) { {} }
  let(:solr_response) { nil }
  let(:document) { SolrDocument.new(source_doc, solr_response) }
  let(:presenter) { described_class.new(document, CatalogController.new) }

  describe 'image' do
    subject { presenter.image }
    context "when there is an image url" do
      let(:url) { 'http://site.dk/image.jpg' }
      let(:source_doc) { { 'image_ssf' => [url] }}
      it 'returns an object tag' do
        expect(subject).to include '<object'
        expect(subject).to include url
      end
    end
  end

  describe 'affiliations' do
    subject { presenter.affiliations }
    it 'returns a hash of affiliations' do
      expect(subject).to be_a Hash
    end
    context 'without affiliation data' do
      it 'returns an empty Hash' do
        expect(subject.size).to eql 0
      end
    end
    context "when there is only current affiliation data" do
      let(:document) {
        Dtu::SolrDocument.new('person_affiliations_ssf' =>
        ["[{\"startDate\":\"20120222\",\"organisation\":{\"names\":[{\"level2\":\"Center for Elektronnanoskopi\",\"level1\":\"Danmarks Tekniske Universitet\",\"acronym\":\"DTU Cen\",\"lang\":\"dan\"}]},\"type\":\"current\"},{\"startDate\":\"20150205\",\"organisation\":{\"names\":[{\"level2\":\"Centers\",\"level3\":\"Center for Nanostruktureret Grafen\",\"level1\":\"Danmarks Tekniske Universitet\",\"acronym\":\"Center for Nanostruktureret Grafen\",\"lang\":\"dan\"}]},\"type\":\"current\"},{\"startDate\":\"20131220\",\"organisation\":{\"names\":[{\"level2\":\"DTU Danchip\",\"level1\":\"Danmarks Tekniske Universitet\",\"acronym\":\"DTU Danchip\",\"lang\":\"dan\"}]},\"type\":\"current\"}]"]
        )
      }
      subject { presenter.affiliations['current'] }
      it 'contains current data' do
        expect(subject).not_to be_empty
      end
      it 'does not contain date information' do
        expect(subject).not_to include '22/02-2012'
      end
    end
  end

  describe 'publications_link' do
    subject { presenter.publications_link }
    context 'when there are less than 10 publications' do
      it 'should return a blank string' do
        allow_any_instance_of(described_class).to receive(:publications).and_return({size: 2})
        expect(subject).to eql ''
      end
    end
  end
end
