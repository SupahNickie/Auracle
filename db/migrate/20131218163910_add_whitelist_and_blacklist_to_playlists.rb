class AddWhitelistAndBlacklistToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :whitelist, :integer, :array => true, :default => []
    add_column :playlists, :blacklist, :integer, :array => true, :default => []
  end
end
