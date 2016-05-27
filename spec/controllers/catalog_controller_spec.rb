describe CatalogController do
  describe 'blacklight_config' do
    describe '.document_presenter_class' do
      subject { controller.blacklight_config.document_presenter_class }
      it { is_expected.to eq Dtu::DocumentPresenter }
    end
    describe '.solr_path' do
      subject { controller.blacklight_config.solr_path }
      it { is_expected.to eq 'ddf_publ' }
    end

    describe 'metrics presenter classes' do
      subject { controller.blacklight_config.metrics_presenter_classes }
      it { is_expected.to eq [ Dtu::Metrics::AltmetricPresenter ] }
    end

    describe 'index_title_field' do
      subject {controller.blacklight_config.index.title_field }
      it { is_expected.to eq 'title_ts' }
    end
    describe 'show_title_field' do
      subject {controller.blacklight_config.show.title_field }
      it { is_expected.to eq 'title_ts' }
    end

    describe 'per_page' do
      subject { controller.blacklight_config.per_page }
      it { is_expected.to eq [ 10, 20, 50 ] }
    end

    describe 'default_solr_params' do
      it 'enables highlighting for some fields' do
        ['author_ts', 'journal_title_ts', 'publisher_ts', 'abstract_ts'].each do |field|
          field_config = controller.blacklight_config.index_fields[field]
          expect(field_config.highlight).to eq true
        end
      end
    end
  end
end
