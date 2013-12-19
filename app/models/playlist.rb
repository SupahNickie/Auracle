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
    array = []
    @songs.each do |song|
      if
        check_fit(@mood, song.average_mood) &&
        check_fit(@timbre, song.average_timbre) &&
        check_fit(@intensity, song.average_intensity) &&
        check_fit(@tone, song.average_tone)
        array << song.id unless @playlist.blacklist.include? song.id
      end
    end
    final_array = (@playlist.whitelist + array)
    last_check_of_presence(final_array, @playlist)
  end

  def change_whitelist(playlist, song, action)
    @playlist = playlist
    @song = song
    @action = action
    if @action == "add"
      whitelist_will_change!
      array = @playlist.whitelist
      array << @song.id
      @playlist.update(:whitelist => array)
    elsif @action == "remove"
      blacklist_will_change!
      array = @playlist.blacklist
      array << @song.id
      if @playlist.whitelist.include? @song.id
        whitelist_will_change!
        whitelist_array = @playlist.whitelist
        whitelist_array.delete(@song.id)
        @playlist.update(:whitelist => whitelist_array)
      end
      @playlist.update(:blacklist => array)
    elsif @action == "unblacklist"
      blacklist_will_change!
      array = @playlist.blacklist
      array.delete(@song.id)
      @playlist.update(:blacklist => array)
    elsif @action == "unwhitelist"
      whitelist_will_change!
      array = @playlist.whitelist
      array.delete(@song.id)
      @playlist.update(:whitelist => array)
    end
  end

private

  def check_fit(attribute_score, attribute)
    return true if
      ((attribute_score - attribute) >= -5 &&
      (attribute_score - attribute) <= 5) ||
      (attribute_score == 0)
  end
end

  def last_check_of_presence(songs, playlist)
    @songs = songs
    @playlist = playlist
    songs_list_will_change!
    @songs.each do |song|
      if Song.find_by_id(song).nil?
        @songs.delete(song)
      end
    end
    @songs = @songs.uniq.sort
    if @playlist.songs_list != @songs
      @playlist.update(:songs_list => @songs)
    end
  end
