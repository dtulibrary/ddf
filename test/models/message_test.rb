require 'minitest_helper'

class MessageMailerTest < ActionMailer::TestCase
  test "new message" do
    # Create the email and store it for further assertions
    email = MessageMailer.new_message_stub(:name => 'James',
                                           :email => 'friend@example.com',
                                           :content => 'This comes from a test')

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['James'], email[:name]
    assert_equal ['from@example.com'], email[:from]
    assert_equal ['to@example.com'], email[:to]
    assert_equal 'This comes from a test', email[:content]
  end
end
