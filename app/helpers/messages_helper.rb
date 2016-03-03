module MessagesHelper
  def general_feedback_mail_link
    "mailto:feedbackforskningsdatabase@dtu.dk?subject=#{u "Feedback on forskningsdatabasen.dk (URL: #{request.url})"}"
  end

  def oa_feedback_mail_link
    "mailto:hlk@fi.dk,jonb@fi.dk?subject=#{u "Feedback on Open Access Indicator (on forskningsdatabasen.dk) (URL: #{request.url})"}"
  end
end
