class Ad < ActiveRecord::Base
  has_and_belongs_to_many :requests

  validates :title, :description,:price, :externid, :externsource, :url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
end
