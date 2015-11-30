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

      describe 'index fields' do
        subject { controller.blacklight_config.index_fields.keys }
        it { is_expected.to eq %w(author_ts format_orig_s journal_title_ts editor_ts abstract_ts research_area_ss series_title_ts publisher_ts pub_date_tis supervisor_ts doi_ss) }
      end

      describe 'facet_fields' do
        subject { controller.blacklight_config.facet_fields.keys }
        it { is_expected.to eq %w(pub_date_tsort format_orig_s submission_year_tis source_ss isolanguage_ss scientific_level_s access_condition_s review_status_s research_area_ss)}
      end

      describe 'show_fields' do
        subject { controller.blacklight_config.show_fields.keys }
        it { is_expected.to eq %w(author_ts subtitle_ts doi_ss abstract_ts isbn_ss format_orig_s affiliation_ts language_ss journal_title_ts editor_ts keywords_ts research_area_ss access_condition_s series_title_ts review_status_s supervisor_ts conf_title_ts publisher_ts submission_year_tis pub_date_tis scientific_level_s cluster_id_ss)}
      end
    end
  end
end