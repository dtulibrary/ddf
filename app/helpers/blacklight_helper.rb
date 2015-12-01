# 23.07.2015: Here or in CatalogHelper?
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior
  include Dtu::DocumentHelper


  def citation_title document
    title = document[blacklight_config.show.title_field]
    (title.kind_of? Array) ? title.first : title
  end

  # The below code moved in to make bookmarks functionality work

  def current_bookmarks response = nil
    response ||= @response
    @current_bookmarks ||= current_or_guest_user.bookmarks_for_documents(response.documents).to_a
  end

  ##
  # Check if the document is in the user's bookmarks
  def bookmarked? document
    current_bookmarks.any? { |x| x.document_id == document.id and x.document_type == document.class }
  end

  alias_method :is_bookmarked?, :bookmarked?
  deprecation_deprecate :is_bookmarked?
end



