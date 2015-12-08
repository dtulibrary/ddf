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
end
