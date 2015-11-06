class CitationMailer < ApplicationMailer
  def send_citations(to, message)
    subject = I18n.t('citations.email.subject')
    mail(to: to,  subject: subject) do |format|
      format.text { render plain: ActionView::Helpers::SanitizeHelper.strip_tags(message) }
      format.html { render html: message.html_safe }
    end
  end
end