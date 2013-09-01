class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.text :description
      t.string :externid
      t.decimal :price
      t.string :url
      t.string :externsource
      t.datetime :createdAt
      t.datetime :updatedAt
      t.text     :address
      t.string   :ownership
      t.string   :state
      t.string   :mapurl
      # extended properties
      t.string   :building_type

      t.timestamps
    end
  end
end
