describe SolrDocument do
  describe '#cris_id' do
    let(:solr_data) { {} }
    let(:document) { SolrDocument.new(solr_data) }
    subject { document.cris_id }
    let(:cris_id) { 'd0ff1f22-b755-48d5-b5c9-94a9ef4367ac' }
    context 'when there is no cris id or backlink' do
      it { should eql nil }
    end
    context 'when there is a cris id' do
      let(:solr_data) { { 'cris_id_ss' => [cris_id] }}
      it { should eql cris_id }
    end
    context 'when there is no crid id but there is a source id' do
      let(:solr_data) { { 'source_id_ss' => [ "rdb_ku:#{cris_id}" ]}}
      it { should eql cris_id }
    end
    context 'when there is no cris id but there is a backlink' do
      let(:solr_data) { { 'backlink_ss' => [
          "https://curis.ku.dk/portal/da/persons/tine-alkjaer(#{cris_id}).html"
        ]}}
      it { should eql cris_id }
    end
  end
end
