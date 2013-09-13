class CreateSearchInfos < ActiveRecord::Migration
  def change
    create_table :search_infos do |t|
      t.integer :resultsCount, default:0
      t.datetime :lastCheckAt
      t.string :lastAdExternId
      t.string :url

      t.timestamps
    end

    create_table :requests_search_infos do |t|
      t.belongs_to :request
      t.belongs_to :search_info
    end
  end
end
