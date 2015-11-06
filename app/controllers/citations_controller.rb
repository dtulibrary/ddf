class CitationsController < CatalogController
  before_action :inject_last_query_into_params, only: [:new, :preview]

  def new
    respond_to do |format|
      format.js { render layout: nil }
      format.html
    end
  end

  def preview
    (@response, @document_list) = search_results(params, search_params_logic)
    respond_to do |format|
      format.js { render layout: nil }
      format.html
    end
  end

  def send_citations
    CitationMailer.send_citations(params[:to], params[:message]).deliver_now
    respond_to do |format|
      format.js { render template: 'catalog/email_success', flash: { success: 'Email sent hooray!' }, layout: nil }
      format.html { render template: 'catalog/email_success', flash: { success: 'Email sent hooray!' } }
    end
  end

  # This passes the search context in to allow us to re-run the active search with modified params if necessary
  def inject_last_query_into_params
    if current_search_session
      current_search_params = current_search_session.query_params.empty? ? {} : current_search_session.query_params
      params.merge!(current_search_params.reject {|k,v| ["controller","action"].include?(k)})
    end
  end
end