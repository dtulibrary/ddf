class FeedbackForm < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Feedback regarding DDF",
      :to => "vhay@dtu.dk",
      :from => %("#{name}" <#{email}>)
    }
  end
end

# ff = FeedbackForm.new(:name => 'James', :email => 'abbottjam@gmail.com', :message => 'Cool!')
# ff.deliver
