# -*- encoding : utf-8 -*-
#

require 'i18n'
class CatalogController < ApplicationController

  include Dtu::CatalogBehavior

  before_filter :set_locale

  configure_blacklight do |config|
    # Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    # solr path which will be added to solr base url before the other solr params.
    config.solr_path = 'ddf_publ'
    config.default_solr_params = {
      :q => '*:*',
      :rows => 10,
      :hl => true,
      'hl.snippets' => 3,
      'hl.usePhraseHighlighter' => true,
      'hl.fl' => 'title_ts, author_ts, journal_title_ts, conf_title_ts, abstract_ts, publisher_ts',
      'hl.fragsize' => 300,
      fq: 'NOT format:person'
    }
    
    config.document_presenter_class = DDFPresenter
    config.metrics_presenter_classes = [ Dtu::Metrics::AltmetricPresenter, Dtu::Metrics::OrcidPresenter ]
    # Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    # parameters included in the Blacklight-jetty document requestHandler.

    config.default_document_solr_params = {
     :qt => '/ddf_publ_document',
     :q => "{!raw f=#{SolrDocument.unique_key} v=$id}"
      # These are hard-coded in the blacklight 'document' requestHandler
      # :fl => '*',
      # :rows => 1
      # :q => '{!raw f=id v=$id}'
    }
    # solr field configuration for search results/index views

    # config.show.display_type_field = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    # config.add_facet_field 'format_orig_s', :label => I18n.t('blacklight.search.fields.facet.format_orig_s'), :helper_method => :render_format_field_facet
    # config.add_facet_field 'pub_date_tsort', :label => I18n.t('blacklight.search.fields.facet.pub_date_tsort'), :range => {
    #   :num_segments => 3,
    #   :assumed_boundaries => [1900, Time.now.year + 2],
    # }

    # ALL FACET FIELDS:
    # TODO - investigate difference with format field as used in Toshokan
    config.add_facet_field 'format_orig_s', :helper_method => :render_format_field_facet
    config.add_facet_field 'pub_date_tsort', :range => {
        :num_segments => 3,
        :assumed_boundaries => [1900, Time.now.year + 2]
    }
    config.add_facet_field 'author_facet', :limit => 10
    config.add_facet_field 'source_ss', :helper_method => :render_source_field_facet, :limit => 10
    config.add_facet_field 'journal_title_facet', :limit => 10
    config.add_facet_field 'submission_year_tis', range: true
    config.add_facet_field 'isolanguage_ss', :helper_method => :render_language_field_facet
    config.add_facet_field 'scientific_level_s', :helper_method => :render_scientific_level_facet
    config.add_facet_field 'access_condition_s', :helper_method => :render_publication_status_facet
    config.add_facet_field 'review_status_s', :helper_method => :render_review_status_facet
    config.add_facet_field 'research_area_ss', :helper_method => :render_research_area_facet
    config.add_facet_field 'cris_id_ss', show: false

    config.add_facet_fields_to_solr_request!

    config.index.display_type_field = 'format'
    config.show.display_type_field = 'format'
    # 08.07.2015. Way to go:
    # https://github.com/projectblacklight/blacklight/wiki/Blacklight-configuration

    # ALL INDEX FIELDS:
    # NOTE: Toshokan uses a helper method here to create author links
    config.add_index_field 'author_ts', :separator => ' ; ', highlight: true, :helper_method => :render_highlight_field
    config.add_index_field 'format_orig_s', :helper_method => :render_format_field_index
    # NOTE: Toshokan uses a somewhat different helper method
    config.add_index_field 'journal_title_ts', :helper_method => :render_journal_info, highlight: true
    config.add_index_field 'editor_ts'
    # NOTE: Toshokan has a method here to render highlighting in the abstract
    config.add_index_field 'abstract_ts', :helper_method => :render_highlighted_abstract, :highlight => true, separator: ''
    config.add_index_field 'research_area_ss'
    config.add_index_field 'series_title_ts'
    # NOTE: Toshokan does the same here but with highlighting
    config.add_index_field 'publisher_ts', highlight: true, :helper_method => :render_publisher
    config.add_index_field 'pub_date_tis', if: :show_publication_year?
    config.add_index_field 'supervisor_ts'
    config.add_index_field 'doi_ss'

    # ALL SHOW FIELDS:
    # NOTE: Toshokan uses a helper method here to create author links
    config.add_show_field 'author_ts', :separator => ' ; '
    config.add_show_field 'subtitle_ts'
    config.add_show_field 'doi_ss'
    config.add_show_field 'abstract_ts'
    config.add_show_field 'isbn_ss'
    config.add_show_field 'format_orig_s', :helper_method => :render_type
    # NOTE: Toshokan uses a helper method here to render affiliations
    config.add_show_field 'affiliation_ts', :separator => '<hr style="margin:0.2em 0em">'.html_safe
    config.add_show_field 'language_ss', :helper_method => :render_language
    # NOTE: Toshokan uses a somewhat different helper method
    config.add_show_field 'journal_title_ts', :helper_method => :render_journal_info
    # NOTE: Toshokan uses the author link helper method here
    config.add_show_field 'editor_ts'
    # NOTE: Toshokan uses a helper method here to create keyword links
    config.add_show_field 'keywords_ts', :separator => '; '
    config.add_show_field 'research_area_ss'
    config.add_show_field 'access_condition_s', :helper_method => :render_publishing_status
    config.add_show_field 'series_title_ts'
    config.add_show_field 'review_status_s', :helper_method => :render_review_status
    # NOTE: Toshokan uses a link creating method here
    config.add_show_field 'supervisor_ts'
    # NOTE: Toshokan has a different helper method here
    config.add_show_field 'conf_title_ts', :helper_method => :render_conf_title
    config.add_show_field 'publisher_ts', :helper_method => :render_publisher
    config.add_show_field 'submission_year_tis'
    config.add_show_field 'pub_date_tis', if: :show_publication_year?
    config.add_show_field 'scientific_level_s', :helper_method => :render_scientific_level

    ################################
    ######## Researchers  ##########
    ################################
    config.add_index_field 'orcid_ss', highlight: true, label: 'ORCID'
    config.add_index_field 'is_active_b', helper_method: :render_status_index
    config.add_show_field 'orcid_ss'
    # config.add_show_field 'person_affiliations_ssf', helper_method: :render_current_affiliations
    config.add_show_field 'is_active_b', helper_method: :render_status_index
    config.add_facet_field 'has_orcid_b', helper_method: :render_orcid_status
    config.add_facet_field 'is_active_b', helper_method: :render_active_status

    config.add_show_field 'cluster_id_ss', unless: :person_doc?
    config.add_show_field 'email_ssf', if: :person_doc?, helper_method: :email_link

    # SORTING

    relevance_ordering = [
        'score desc',
        'pub_date_tsort desc',
        'journal_vol_tsort desc',
        'journal_issue_tsort desc',
        'journal_page_start_tsort asc',
        'title_sort asc'
    ]
    year_ordering = [
        'pub_date_tsort desc',
        'journal_vol_tsort desc',
        'journal_issue_tsort desc',
        'journal_page_start_tsort asc',
        'title_sort asc'
    ]
    title_ordering = [
        'title_sort asc',
        'pub_date_tsort desc'
    ]
    name_ordering = [
      'name_sort asc'
    ]

    config.add_sort_field relevance_ordering.join(', '), :label => 'relevance'
    config.add_sort_field year_ordering.join(', '), :label => 'year', unless: :researcher_search?
    config.add_sort_field title_ordering.join(', '), :label => 'title', unless: :researcher_search?
    config.add_sort_field name_ordering.join(', '), :label => 'name', if: :researcher_search?


    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.
    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'publications', label: I18n.t('ddf.search.fields.publications')

    # Limit results to researchers
    # In our solrconfig.xml we have created a person_qf
    # configuration to limit searches to name and orcid fields.
    config.add_search_field('researchers') do |field|
      field.label = I18n.t('ddf.search.fields.researchers')
      field.solr_local_parameters = {
        qf: '$person_qf'
      }
      field.solr_parameters = {
        fq: 'format:person AND NOT source_ss:rdb_ucviden AND has_publications_b:true',
        'hl.fl' => 'orcid_ss'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).

  end

  def show
    super()
    # binding.pry
  end
end
