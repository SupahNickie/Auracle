class AddIndicesToScores < ActiveRecord::Migration
  def change
    add_index :songs, :average_mood
    add_index :songs, :average_timbre
    add_index :songs, :average_intensity
    add_index :songs, :average_tone
  end
end
