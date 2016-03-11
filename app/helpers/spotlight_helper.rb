module SpotlightHelper
  include Spotlight::MainAppHelpers

  def within_spotlight?
    controller.class.to_s.include? 'Spotlight'
  end

  ##
  # Overrides default Blacklight behaviour to disable
  # Search bar on Spotlight pages.
  # Render the search navbar
  # @return [String]
  def render_search_bar
    unless within_spotlight? && defined?(@exhibit) && !@exhibit.searchable?
      render :partial=>'catalog/search_form'
    end
  end

  # link_to_document(doc, 'VIEW', :counter => 3)
  # link_to_document(doc, :label=>'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a HashWithIndifferentAccess object. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  def link_to_document(doc, field_or_opts = nil, opts={:counter => nil})
    if field_or_opts.is_a? Hash
      opts = field_or_opts
      if opts[:label]
        Deprecation.warn self, "The second argument to link_to_document should now be the label."
        field = opts.delete(:label)
      end
    else
      field = field_or_opts
    end

    field ||= document_show_link_field(doc)
    label = presenter(doc).render_document_index_label field, opts
    # We need to ensure that we're getting a path to the catalog show pag
    # Not the Spotlight catalog sub page
    if within_spotlight?
      link_to label, solr_document_path(doc), document_link_params(doc, opts)
    else
      link_to label, url_for_document(doc), document_link_params(doc, opts)
    end
  end
end
