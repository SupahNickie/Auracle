class AddUserIdAndAlbumIdToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :user_id, :integer
    add_column :songs, :album_id, :integer
  end
end
