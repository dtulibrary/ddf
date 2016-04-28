describe SolrService do
  describe 'cris_search' do
    let(:cris_ids) { []}
    let(:cris1) { '92486aea-3a9f-4cba-8eda-5cebc70fa6f4' }
    let(:cris2) { 'e9cb81fb-811a-4ace-b9f5-270c89a648dd' }
    subject { described_class.cris_search(cris_ids) }
    context 'when there are multiple cris ids' do
      let(:cris_ids) { [cris1, cris2 ]}
      it 'should bracket the ids with an OR' do
        expect(subject).to eql "(#{cris1} OR #{cris2})"
      end
    end
    context 'when there is only one cris id' do
      let(:cris_ids) { [cris1] }
      it { should eql cris1 }
    end
  end
end
