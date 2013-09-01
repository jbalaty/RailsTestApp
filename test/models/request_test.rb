# encoding: UTF-8
require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  test "request attributes must not be empty" do
    request = Request.new
    assert request.invalid?
    assert request.errors[:title].any?
    assert request.errors[:url].any?
  end

  test "request url should be validated" do
    r = Request.new(
        title:"My Book Title",
        url: "yyy"
    )
    assert r.invalid?
    assert_equal ["is invalid"], r.errors[:url]

    r.url = "http://aaaa"
    refute r.invalid?

    r.url = "http:/aaaaěščěšč"
    assert r.invalid?

    r.url = "http://aaaa"
    refute r.invalid?

    r.url = "http:/aaaa"
    assert r.invalid?
  end
end
