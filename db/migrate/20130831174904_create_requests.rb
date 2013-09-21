class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :title # custom name for this request
      t.string :url # url from external system
      t.boolean :processed, default: false
      t.integer :numFailedAttempts, default:0
      t.datetime :firstFailedAttempt

      t.timestamps
    end

    create_table :requests_watched_resources do |t|
      t.belongs_to :watched_resource
      t.belongs_to :request
    end
  end
end
