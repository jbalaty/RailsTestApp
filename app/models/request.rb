class Request < ActiveRecord::Base
  has_and_belongs_to_many :ad

  validates :title, :url, presence: true
  validates :url, :format => URI::regexp(%w(http https))
end
