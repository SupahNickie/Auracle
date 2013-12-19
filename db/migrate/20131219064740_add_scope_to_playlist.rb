class AddScopeToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :scope, :string
  end
end
