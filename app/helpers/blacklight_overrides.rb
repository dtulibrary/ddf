module BlacklightOverrides
  ##
  # Check if a document has (or, might have, in the case of accessor methods) a value for
  # the given solr field
  # @param [SolrDocument] document
  # @param [Blacklight::Solr::Configuration::SolrField] solr_field
  # @return [Boolean]
  def document_has_value? document, field_config
    byebug
    document.has?(field_config.field) ||
      (document.has_highlight_field? field_config.field if field_config.highlight) ||
      field_config.accessor
  end

end
