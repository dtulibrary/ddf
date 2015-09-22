class MessageMailer < ApplicationMailer

  default from: "from@example.com"
  default to:   "to@example.com"

  def new_message(message)
    @message = message

    mail subject: "Message from #{message.name}"
  end
end
