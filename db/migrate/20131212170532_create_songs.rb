class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.attachment :mp3
      t.string :link_to_purchase
      t.string :link_to_download
      t.integer :average_mood
      t.integer :average_timbre
      t.integer :average_intensity
      t.integer :average_tone
      t.integer :mood, :array => true, :default => []
      t.integer :timbre, :array => true, :default => []
      t.integer :intensity, :array => true, :default => []
      t.integer :tone, :array => true, :default => []

      t.timestamps
    end
  end
end
