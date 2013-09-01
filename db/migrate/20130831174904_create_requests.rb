class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :title
      t.string :url
      t.string :email
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end
