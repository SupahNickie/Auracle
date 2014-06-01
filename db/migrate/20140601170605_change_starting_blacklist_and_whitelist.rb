class ChangeStartingBlacklistAndWhitelist < ActiveRecord::Migration
  def change
    change_column :playlists, :whitelist, :integer, :array => true, :default => "{0}"
    change_column :playlists, :blacklist, :integer, :array => true, :default => "{0}"
  end
end
