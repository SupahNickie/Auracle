class RemoveExtraneousColumns < ActiveRecord::Migration
  def change
    remove_column :albums, :user_id
    remove_column :songs, :user_id
  end
end
