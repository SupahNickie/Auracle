require 'mime/types'

class Song < ActiveRecord::Base

  belongs_to :album
  # has_many :playlist_songs
  # has_many :playlists, through: :playlist_songs
  has_attached_file :mp3

  def add_attributes_to_array(mood_score, timbre_score, intensity_score, tone_score)
    mood_will_change! unless mood_score == 0
    timbre_will_change! unless timbre_score == 0
    intensity_will_change! unless intensity_score == 0
    tone_will_change! unless tone_score == 0
    scores = [mood_score, timbre_score, intensity_score, tone_score]
    mood << scores[0]
    timbre << scores[1]
    intensity << scores[2]
    tone << scores[3]
  end

end
