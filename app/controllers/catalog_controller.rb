# -*- encoding : utf-8 -*-
#
class CatalogController < ApplicationController

  include Blacklight::Catalog

  configure_blacklight do |config|
    # Ensure I18n load paths are loaded
    Dir[Rails.root + 'config/locales/**/*.{rb,yml}'].each { |path| I18n.load_path << path }


    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      :qt => '/ddf_publ',
      :rows => 10
  }
    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'
    # items to show per page, each number in the array represent another option to choose from.
    config.per_page = [10,20,50]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
     :qt => '/ddf_publ_document',
     :q => "{!raw f=#{SolrDocument.unique_key} v=$id}"
      ## These are hard-coded in the blacklight 'document' requestHandler
      # :fl => '*',
      # :rows => 1
      # :q => '{!raw f=id v=$id}'
  }
    # solr field configuration for search results/index views
    config.index.title_field = 'title_ts'
    config.index.display_type_field = 'format'
    config.index.source_id = 'source_ss'
    config.index.affiliation_field = 'affiliation_ts'
    config.index.doi_id = 'doi_ss'

    # solr field configuration for document/show views
    config.show.title_field = 'title_ts'
    config.show.display_type_field = 'format'
    config.show.affiliation_field = 'affiliation_ts'
    config.show.source_id = 'source_ss'
    config.show.conference_field = 'conf_title_ts'
    config.show.publisher_field = 'publisher_ts'
    config.show.isbn_id = 'isbn_ss'
    config.show.issn_id = 'issn_ss'
    config.show.doi_id = 'doi_ss'
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
    config.add_facet_field 'format', :label => 'Type'
    config.add_facet_field 'author_facet', :label => I18n.t('blacklight.search.fields.facet.author_facet'), :limit => 10
    config.add_facet_field 'journal_title_facet', :label => I18n.t('blacklight.search.fields.facet.journal_title_facet'), :limit => 10
    config.add_facet_field 'research_area_ss', :label => I18n.t('blacklight.search.fields.facet.research_area_ss'), :limit => 10

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    # The ordering of the field names is the order of the display

    # 08.07.2015. Way to go:
    # https://github.com/projectblacklight/blacklight/wiki/Blacklight-configuration
    #
    # :helper_methods result in errors, so don't use'em:
    # config.add_index_field 'abstract_ts', :helper_method => :snip_abstract
    # config.add_index_field 'journal_title_ts', :helper_method => :render_journal_info

    # ALL INDEX FIELDS:
    config.add_index_field 'author_ts', :separator => ' ; '
    config.add_index_field 'format', :label => 'Type'
    # config.add_index_field 'doi_ss'
    config.add_index_field 'journal_title_ts', :label => 'Published in'
    config.add_index_field 'abstract_ts', :label => 'Abstract'
    config.add_index_field 'research_area_ss', :label => 'Research Area'



    # TODO: Enable this when research area codes are available
    #config.add_index_field 'research_area_ss', :label => 'Research Area', :helper_method => :render_research_area_field
    config.add_index_field 'series_title_ts'
    # config.add_index_field 'source_ss', :helper_method => :render_source_field
    # solr fields to be displayed in the show (single result) view
    # The ordering of the field names is the order of the display
    config.add_show_field 'author_ts', :separator => ' ; '
    config.add_show_field 'affiliation_ts'
    # config.add_show_field 'format', :helper_method => :render_format_field_index
    # config.add_show_field 'journal_title_ts',:helper_method => :render_journal_info
    config.add_show_field 'publisher_ts'
    config.add_show_field 'doi_ss'
    config.add_show_field 'isbn_ss'
    config.add_show_field 'issn_ss'

    # UGH?
    # config.add_show_field 'abstract_ts', :helper_method => :snip_abstract

    config.add_show_field 'conf_title_ts'
    config.add_show_field 'language_ss'
    # TODO: Enable this when research area codes are available
    #config.add_show_field 'research_area_ss', :label => 'Research Area', :helper_method => :render_research_area_field
    config.add_show_field 'series_title_ts'
    config.add_show_field 'research_area_ss'
    # config.add_show_field 'source_ss', :helper_method => :render_source_field
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
    config.add_search_field 'all_fields', :label => 'Title'
    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).

config.add_sort_field 'score desc, pub_date_tsort desc, journal_vol_tsort desc, journal_issue_tsort desc, journal_page_start_tsort asc, title_sort asc', :label => 'relevance'
config.add_sort_field 'pub_date_tsort desc, journal_vol_tsort desc, journal_issue_tsort desc, journal_page_start_tsort asc, title_sort asc', :label => 'year'
config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
config.add_sort_field 'title_sort asc, pub_date_tsort desc', :label => 'title'
end
end
