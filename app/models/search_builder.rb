class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  include Spotlight::Catalog::AccessControlsEnforcement::SearchBuilder

  # skip the Spotlight visibility check because all docs are visible
  def apply_permissive_visibility_filter(solr_params)
    return unless current_exhibit
    return if scope.respond_to?(:can?) && scope.can?(:curate, current_exhibit) && !blacklight_params[:public]

    # solr_params.append_filter_query "-#{Spotlight::SolrDocument.visibility_field(current_exhibit)}:false"
  end
end
