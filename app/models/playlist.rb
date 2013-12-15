class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :songs
  has_many :albums, through: :songs

  def find_music(playlist, songs, mood, timbre, intensity, tone)
    @playlist = playlist
    @songs = songs
    @mood = mood.to_i
    @timbre = timbre.to_i
    @intensity = intensity.to_i
    @tone = tone.to_i
    songs_list_will_change!
    array = []
    @songs.each do |song|
      if
        check_fit(@mood, song.average_mood) &&
        check_fit(@timbre, song.average_timbre) &&
        check_fit(@intensity, song.average_intensity) &&
        check_fit(@tone, song.average_tone)
        array << song
      end
    end
    @playlist.update(:songs_list => array)
  end

  def check_if_songs_present(playlist)
    @playlist = playlist
    songs_list_will_change!
    array = @playlist.songs_list
    array.each do |song|
      if Song.find_by_id(song).nil?
        array.delete(song)
      end
    end
    @playlist.update(:songs_list => array)
  end

private

  def check_fit(attribute_score, attribute)
    return true if
      ((attribute_score - attribute) >= -5 &&
      (attribute_score - attribute) <= 5) ||
      (attribute_score == 0)
  end
end
