class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include Spotlight::Catalog::AccessControlsEnforcement::SearchBuilder

  def apply_permissive_visibility_filter(_)
  end
end
