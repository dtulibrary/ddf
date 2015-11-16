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
    # otherwise we are redoing the previous search but with changed rows param
    if params[:id].present?
      (@response, @document) = get_solr_response_for_doc_id
      @document_list = [@document]
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
end