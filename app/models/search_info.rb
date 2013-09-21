class SearchInfo < ActiveRecord::Base
  has_one :watched_resource, as: :polymorhicWatchedResource

end
