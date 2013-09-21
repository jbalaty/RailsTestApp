class WatchedResource < ActiveRecord::Base
  belongs_to :polymorhicWatchedResource, polymorphic: true
  has_and_belongs_to_many :requests
end
