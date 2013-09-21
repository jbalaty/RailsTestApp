class CreateWatchedResources < ActiveRecord::Migration
  def change
    create_table :watched_resources do |t|
      t.string :type
      t.string :urlNormalized # normalized extern url
      t.string :usage, default: 'user'
      t.string :externId, length: 1024 # identifier of resource in external system
      t.string :externsource # external system name string = eg. sreality
      t.datetime :lastCheckAt
      t.integer :numFailedChecks
      t.datetime :firstFailedCheck
      t.integer :resultsCount
      t.string :lastExternId, length: 1000

      t.timestamps
    end

    #create_table :ads do |t|
    #  t.string :title
    #  t.decimal :price
    #  t.string :infoState # state of completeness, basic|detail
    #  t.string :mapurl
    #  t.string :ownership
    #  t.text :description
    #
    #  t.timestamps
    #end
  end
end
