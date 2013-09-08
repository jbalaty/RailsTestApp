class CreateRequestsAds < ActiveRecord::Migration
  def change
    create_table :ads_requests do |t|
      t.belongs_to :request
      t.belongs_to :ad
    end
  end
end
