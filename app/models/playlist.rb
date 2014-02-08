class Playlist < ActiveRecord::Base
  belongs_to :user

  def slug
    name.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

  def find_music(playlist, songs, mood, timbre, intensity, tone, scope)
    @playlist = playlist
    @songs = songs
    @mood = mood.to_i
    @timbre = timbre.to_i
    @intensity = intensity.to_i
    @tone = tone.to_i
    @scope = scope
    array = []
    whitelist_array = []
    @playlist.whitelist.each do |song|
      whitelist_array << song
    end
    blacklist_array = []
    @playlist.blacklist.each do |song|
      blacklist_array << song
    end
    @songs.each do |song|
      if
        check_fit(@mood, song.average_mood, @scope) &&
        check_fit(@timbre, song.average_timbre, @scope) &&
        check_fit(@intensity, song.average_intensity, @scope) &&
        check_fit(@tone, song.average_tone, @scope)
        array << song.id unless @playlist.blacklist.include? song.id
      end
    end
    final_array = (@playlist.whitelist + array)
    last_check_of_presence(final_array, @playlist, whitelist_array, blacklist_array)
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

  def check_fit(attribute_score, attribute, scope)
    @scope = scope
    if @scope == "expansive"
      @scope = 8
    elsif @scope == "loose"
      @scope = 5
    elsif @scope == "strict"
      @scope = 2
    end
    return true if
      ((attribute_score - attribute) >= -@scope &&
      (attribute_score - attribute) <= @scope) ||
      (attribute_score == 0)
  end
end

  def last_check_of_presence(songs, playlist, original_whitelist, original_blacklist)
    @songs = songs
    @playlist = playlist
    @original_whitelist = original_whitelist
    @original_blacklist = original_blacklist
    songs_list_will_change!
    whitelist_will_change!
    blacklist_will_change!
    white_array = @playlist.whitelist
    @songs.each do |song|
      if Song.find_by_id(song).nil?
        @songs.delete(song)
        white_array.delete(song)
        black_array.delete(song)
      end
    end
    @playlist.blacklist.each do |song|
      if Song.find_by_id(song).nil?
        @playlist.blacklist.delete(song)
      end
    end
    if white_array != @original_whitelist
      @playlist.update(:whitelist => white_array)
    end
    if @playlist.blacklist != @original_blacklist
      @playlist.update(:blacklist => @playlist.blacklist)
    end
    @songs = @songs.uniq.sort
    if @playlist.songs_list != @songs
      @playlist.update(:songs_list => @songs)
    end
  end
