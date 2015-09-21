class FeedbackFormsController < ApplicationController
  def new
    @feedback_form = FeedbackForm.new
  end

  def create
    begin
      @feedback_form = FeedbackForm.new(params[:feedback_form])
      @feedback_form.request = request
      if @feedback_form.deliver!
        flash.now[:notice] = 'Thank you for your message!'
      else
        # binding.pry
        flash.now[:notice] = 'Message not delivered'
        render :new
      end
    rescue ScriptError
      flash[:error] = 'Sorry, this message appears to be spam and was not delivered.'
    end
  end


  # def create
  #   @contact_form = ContactForm.new(params[:contact_form])
  #   @contact_form.request = request
  #   if @contact_form.deliver
  #     flash.now[:notice] = 'Thank you for your message!'
  #   else
  #     render :new
  #   end
  # rescue ScriptError
  #   flash[:error] = 'Sorry, this message appears to be spam and was not delivered.'
  # end

end
