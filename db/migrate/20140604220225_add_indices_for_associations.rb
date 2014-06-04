class AddIndicesForAssociations < ActiveRecord::Migration
  def change
    add_index :albums, :user_id
    add_index :songs, :album_id
  end
end
