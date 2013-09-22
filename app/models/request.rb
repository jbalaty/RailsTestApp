class Request < ActiveRecord::Base
  has_and_belongs_to_many :search_infos

  validates :title, :url, presence: true
  validates :url, :format => URI::regexp(%w(http https))

  def addFailedAttempt
    self.numFailedAttempts += 1;
    if !self.firstFailedAttempt
      self.firstFailedAttempt = DateTime.now
    end
  end
end
