class RequestExtendedProperties < ActiveRecord::Migration
  def change
    add_column :requests, :failedAttempts, :integer, default: 0
  end
end

