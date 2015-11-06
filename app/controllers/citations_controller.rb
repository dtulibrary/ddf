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
    (@response, @document_list) = search_results(params, search_params_logic)
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