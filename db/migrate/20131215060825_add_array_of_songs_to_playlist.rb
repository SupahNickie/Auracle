class AddArrayOfSongsToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :songs_list, :integer, :array => true, :default => []
  end
end
