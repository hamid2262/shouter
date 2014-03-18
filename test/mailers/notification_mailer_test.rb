require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "comment_notification_to_shout_owner" do
    mail = NotificationMailer.comment_notification_to_shout_owner
    assert_equal "Comment notification to shout owner", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
