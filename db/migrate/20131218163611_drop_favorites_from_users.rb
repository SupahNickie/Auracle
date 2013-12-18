class DropFavoritesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :favorites
  end
end
