class AddRatingsColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ratings, :integer, :array => true, :default => []
  end
end
