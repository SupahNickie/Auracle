require 'mime/types'

class Song < ActiveRecord::Base
  belongs_to :album
  has_attached_file :mp3

  def add_attributes_to_array(song, mood_score, timbre_score, intensity_score, tone_score)
    @song = song
    mood_will_change! unless mood_score == 0
    timbre_will_change! unless timbre_score == 0
    intensity_will_change! unless intensity_score == 0
    tone_will_change! unless tone_score == 0
    attribute_scores = [mood_score.to_i, timbre_score.to_i, intensity_score.to_i, tone_score.to_i]
    scores = []
    attribute_scores.each do |attribute|
      if (attribute > 0) && (attribute < 101)
        scores << attribute
      else
        scores << 'Not valid'
      end
    end
    @song.mood << scores[0] unless scores[0].is_a? String
    @song.timbre << scores[1] unless scores[1].is_a? String
    @song.intensity << scores[2] unless scores[2].is_a? String
    @song.tone << scores[3] unless scores[3].is_a? String
  end

  def new_average(song)
    @song = song
    @song.update(:average_mood => (mood.reduce :+)/mood.count)
    @song.update(:average_timbre => (timbre.reduce :+)/timbre.count)
    @song.update(:average_intensity => (intensity.reduce :+)/intensity.count)
    @song.update(:average_tone => (tone.reduce :+)/tone.count)
  end

end
