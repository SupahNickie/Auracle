class AddFavoritesColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorites, :integer, :array => true, :default => []
  end
end
