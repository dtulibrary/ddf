describe CatalogHelper do
  describe 'render_source_field_facet' do
    subject { helper.render_source_field_facet(source) }
    context 'using an inherited value' do
      let(:source) { :orbit }
      it 'uses the default values from the sources' do
        expect(subject).to eql I18n.t('mxd_type_labels.source_labels.orbit')
      end
    end
    context 'using an overridden value' do
      let (:source) { :rdb_ark }
      it 'overwrites with an updated value for rdb_ark' do
        expect(subject).to eql I18n.t('mxd_type_labels.facet_source_labels.rdb_ark')
      end
    end
  end

  describe 'highwire metadata' do
    let(:document) do
      SolrDocument.new(
        author_ts: authors, journal_title_ts: journal_titles,
        subformat_s: subformat, issn_ss: issns
      )
    end
    let(:authors) { ['Sample Author', 'Another Author', 'Lastname, Firstname'] }
    let(:journal_titles) { ['Diabetic Medicine', 'Diab Med'] }
    let(:subformat) { }
    let(:issns) { ['14752840'] }
    describe 'citation_tags_for' do
      subject { citation_tags_for(document) }
      it { should_not be nil }
      it 'should only return one journal title' do
        expect(subject).to include 'Diabetic Medicine'
        expect(subject).not_to include 'Diab Med'
      end
      it 'should write authors with firstname first' do
        expect(subject).to include '"Firstname Lastname"'
      end
      it 'should format issn correctly' do
        expect(subject).to include '1475-2840'
      end
      context 'with no journal title' do
        let(:journal_titles) { [] }
        it { should_not include "citation_journal_title" }
      end
      context 'bookchapter' do
        let(:subformat) { 'bookchapter' }
        let(:issns) { }
        it { should include 'citation_inbook_title' }
        it { should_not include 'citation_journal_title' }
      end
    end

    describe 'citation_tag' do
      subject { split_citation_tags_for(:author, authors) }
      it { should include '<meta name="citation_author" content="Sample Author"' }
      it { should include '<meta name="citation_author" content="Another Author"' }
    end
  end

  describe 'space_separated_number' do
    subject { space_separated_number(number) }
    context 'normal number' do
      let(:number) {'12345678'}
      it { should eql '12 34 56 78'}
    end
    context 'with international code' do
      let(:number) { '+45268903'}
      it { should eql '+45 26 89 03'}
    end
    context 'with random dash' do
      let(:number) { '353-89034' }
      it { should eql '35 38 90 34'}
    end
    context 'with loads of mess' do
      let(:number) { '+45 3A5 36_ 37 38-'}
      it { should eql '+45 35 36 37 38'}
    end
  end
end
