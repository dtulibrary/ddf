describe SolrDocument do
  let(:solr_data) { {} }
  let(:document) { SolrDocument.new(solr_data) }
  describe '#cris_id' do
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
  describe 'cris_ids' do
    subject { document.cris_ids }
    context "when there are no source ids" do
      let(:solr_data) { {} }
      it { should eql [] }
    end
    context "when there are multiple source ids" do
      let(:cris1) { '92486aea-3a9f-4cba-8eda-5cebc70fa6f4' }
      let(:cris2) { 'e9cb81fb-811a-4ace-b9f5-270c89a648dd' }
      let(:solr_data) { { 'source_id_ss' => ["rdb_vbn:#{cris1}", "rdb_au:#{cris2}"]}}
      it { should include cris1 }
      it { should include cris2 }
    end
  end
end
