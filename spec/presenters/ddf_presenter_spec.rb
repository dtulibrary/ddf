describe DDFPresenter do
  let(:source_doc) { {} }
  let(:solr_response) { nil }
  let(:document) { SolrDocument.new(source_doc, solr_response) }
  let(:presenter) { described_class.new(document, CatalogController.new) }
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
    context 'with previous affiliation data' do
      let(:document) {
        Dtu::SolrDocument.new('person_affiliations_ssf' =>
          ["[{\"startDate\":\"20120225\",\"organisation\":{\"names\":[{\"level2\":\"Institut for Vand og Miljøteknologi\",\"level3\":\"Residual Resource Engineering\",\"level1\":\"Danmarks Tekniske Universitet\",\"acronym\":\"Residual Resource Engineering\",\"lang\":\"dan\"}]},\"endDate\":\"20130902\",\"type\":\"previous\"}]"])
      }
      subject { presenter.affiliations['previous'] }
      it 'contains previous data' do
        expect(subject).not_to be_empty
      end
      it 'groups the affiliation data together' do
        expect(subject).to include 'Danmarks Tekniske Universitet - Institut for Vand og Miljøteknologi - Residual Resource Engineering'
      end
      it 'contains the date information' do
        expect(subject).to include '25/02-2012'
        expect(subject).to include '02/09-2013'
      end
      it 'contains HTML date entities' do
        expect(subject).to include '<time datetime="2012-02-25">'
      end
    end
    context "when there is multiple previous affiliations" do
      let(:document) {
        Dtu::SolrDocument.new('person_affiliations_ssf' =>
        ["[{\"startDate\":\"19900801\",\"organisation\":{\"names\":[{\"level2\":\"Det Sundhedsvidenskabelige Fakultet\",\"level3\":\"Institut for Klinisk Medicin\",\"level1\":\"Københavns Universitet\",\"acronym\":\"DIAGNOS_FAG\",\"lang\":\"dan\",\"level4\":\"LUKKET: Diagnostiske Fag\"}]},\"endDate\":\"20131003\",\"type\":\"previous\"},{\"startDate\":\"20110825\",\"organisation\":{\"names\":[{\"level2\":\"Det Sundhedsvidenskabelige Fakultet\",\"level3\":\"Institut for Klinisk Medicin\",\"level1\":\"Københavns Universitet\",\"acronym\":\"IKM\",\"lang\":\"dan\"}]},\"endDate\":\"20120824\",\"type\":\"previous\"},{\"startDate\":\"19900801\",\"organisation\":{\"names\":[{\"level2\":\"Det Sundhedsvidenskabelige Fakultet\",\"level3\":\"Institut for Klinisk Medicin\",\"level1\":\"Københavns Universitet\",\"acronym\":\"Inst. Kli. Med.\",\"lang\":\"dan\",\"level4\":\"Institut for Klinisk Medicin\"}]},\"endDate\":\"20140402\",\"type\":\"previous\"}]"]
      )}
      subject { presenter.affiliations['previous'] }
      it 'sorts the previous affiliations by latest finished' do
        expect(subject.index('02/04-2014')).to be < subject.index('03/10-2013')
      end
    end
  end
end
