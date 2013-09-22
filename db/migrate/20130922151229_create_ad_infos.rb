class CreateAdInfos < ActiveRecord::Migration
  def change
    create_table :ad_infos do |t|
      t.string :urlNormalized # normalized extern url
      t.string :externId, length: 1024 # identifier of resource in external system
      t.string :externSource # external system name string = eg. sreality
      t.datetime :lastCheckAt
      t.integer :numFailedChecks
      t.datetime :firstFailedCheck
      t.string :infoState, default: 'basic' # state of completeness, basic|detail

      t.string :title
      t.text :description
      t.decimal :price
      t.string :priceNotice
      t.string :priceType
      t.string :shortAddress
      t.string :mapurl
      t.string :ownership

      t.timestamps
    end
  end
end
