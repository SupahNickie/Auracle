require 'mime/types'

class Song < ActiveRecord::Base

  belongs_to :album
  # has_many :playlist_songs
  # has_many :playlists, through: :playlist_songs
  has_attached_file :mp3

  def add_attributes_to_array(song, mood_score, timbre_score, intensity_score, tone_score)
    @song = song
    mood_will_change! unless mood_score == 0
    timbre_will_change! unless timbre_score == 0
    intensity_will_change! unless intensity_score == 0
    tone_will_change! unless tone_score == 0
    scores = [mood_score, timbre_score, intensity_score, tone_score]
    @song.mood << scores[0].to_i
    @song.timbre << scores[1].to_i
    @song.intensity << scores[2].to_i
    @song.tone << scores[3].to_i
  end

  def new_average(song)
    @song = song
    @song.update(:average_mood => (mood.reduce :+)/mood.count)
    @song.update(:average_timbre => (timbre.reduce :+)/timbre.count)
    @song.update(:average_intensity => (intensity.reduce :+)/intensity.count)
    @song.update(:average_tone => (tone.reduce :+)/tone.count)
  end

end
