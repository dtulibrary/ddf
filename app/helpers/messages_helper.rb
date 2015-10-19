module MessagesHelper

  def feedback_mail_link
    "mailto:feedbackforskningsdatabase@dtu.dk?subject=#{u "Feedback on forskningsdatabasen.dk (URL: #{request.url})"}"
  end

end
