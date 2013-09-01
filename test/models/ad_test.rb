require 'test_helper'

class AdTest < ActiveSupport::TestCase
  fixtures :ads

  test "product attributes must not be empty" do
    ad = Ad.new
    #ad.price = 123;
    assert ad.invalid?
    assert ad.errors[:title].any?
    assert ad.errors[:description].any?
    assert ad.errors[:price].any?
    assert ad.errors[:url].any?
    assert ad.errors[:externid].any?
    assert ad.errors[:externsource].any?
  end
end
