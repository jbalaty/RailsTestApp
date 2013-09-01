class Request < ActiveRecord::Base
  validates :title, :url, presence: true
  validates :url, :format => URI::regexp(%w(http https)) end
