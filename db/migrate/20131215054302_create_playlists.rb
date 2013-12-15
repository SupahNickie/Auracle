class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name
      t.integer :mood
      t.integer :timbre
      t.integer :intensity
      t.integer :tone

      t.timestamps
    end
  end
end
