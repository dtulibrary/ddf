class DDFPresenter < Dtu::DocumentPresenter
  include ActionView::Context

  # Show value of name field if document is person
  # Otherwise use the generic method
  def document_show_html_title
    document.person? ? person_name : super
  end

  def person_name
    document['name_ts'].first || document.id
  end
end
