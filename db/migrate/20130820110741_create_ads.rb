class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.text :description
      t.string :externid
      t.decimal :price
      t.string :url
      t.string :externsource

      t.timestamps
    end
  end
end
