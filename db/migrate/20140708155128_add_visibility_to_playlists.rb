class AddVisibilityToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :invisible, :boolean, :default => false
    Playlist.update_all(invisible: false)
  end
end
