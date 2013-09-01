class AddCheckToAd < ActiveRecord::Migration
  def change
    add_column :ads, :lastCheckAt, :datetime
    add_column :ads, :lastCheckResponseStatus, :string
  end
end
