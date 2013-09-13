class Request < ActiveRecord::Base
  has_and_belongs_to_many :ads
  has_and_belongs_to_many :search_infos

  validates :title, :url, presence: true
  validates :url, :format => URI::regexp(%w(http https))
  validates :email, presence:true
end
