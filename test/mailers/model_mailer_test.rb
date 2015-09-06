require 'test_helper'

class ModelMailerTest < ActionMailer::TestCase
  test "new_update_notification" do
    mail = ModelMailer.new_update_notification
    assert_equal "New update notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
