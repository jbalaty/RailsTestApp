require 'test_helper'

class ChangeNotifierTest < ActionMailer::TestCase
  test "SearchInfoChangeSummary" do
    mail = ChangeNotifier.SearchInfoChangeSummary
    assert_equal "Searchinfochangesummary", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
