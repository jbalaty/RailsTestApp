class Ad < ActiveRecord::Base
  has_one :watched_resource, as: :polymorhicWatchedResource

  #validates :title, :description, :price, :externid, :externsource, :url, presence: true
  #validates :price, numericality: {greater_than_or_equal_to: 0.01}

end
