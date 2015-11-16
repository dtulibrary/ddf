class CitationsController < CatalogController
  before_action :inject_last_query_into_params, only: [:new, :preview]

  def new
    respond_to do |format|
      format.js { render layout: nil }
      format.html
    end
  end

  def preview
    validate_email_params
    # if there is an id present we are only retrieving one result
    if params[:id].present?
      (@response, @document) = get_solr_response_for_doc_id
      @document_list = [@document]
    # If we are coming from the bookmarks controller then we want to export the bookmarks
    elsif current_search_session.query_params['controller'] == 'bookmarks'
      bookmarks = token_or_current_or_guest_user.bookmarks
      bookmark_ids = bookmarks.collect { |b| b.document_id.to_s }
      @response, @document_list = get_solr_response_for_document_ids(bookmark_ids, rows: bookmark_ids.size)
    # otherwise we are coming from a search context and want to redo the search with changed rows params
    else
      (@response, @document_list) =  get_search_results(params)
    end
    respond_to do |format|
      format.js { render layout: nil }
      format.html
    end
  end

  def send_citations
    CitationMailer.send_citations(params[:to], params[:message]).deliver_now
    redirect_to :back, flash: { success: I18n.t('citations.email.sent', to: params[:to]) }
  end

  # This passes the search context in to allow us to re-run the active search with modified params if necessary
  def inject_last_query_into_params
    if current_search_session
      current_search_params = current_search_session.query_params.empty? ? {} : current_search_session.query_params
      params.merge!(current_search_params.reject {|k,v| ["controller","action"].include?(k)})
    end
  end

  # This has been copied over from bookmarks controller

  def token_or_current_or_guest_user
    token_user || current_or_guest_user
  end

  def token_user
    @token_user ||= if params[:encrypted_user_id]
                      user_id = decrypt_user_id params[:encrypted_user_id]
                      User.find(user_id)
                    else
                      nil
                    end
  end
end