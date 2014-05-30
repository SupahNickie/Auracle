class Playlist < ActiveRecord::Base
  belongs_to :user

  def slug
    name.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

  def find_music(playlist, mood, timbre, intensity, tone, scope)
    case scope
    when "expansive" then scope = 8
    when "loose" then scope = 5
    when "strict" then scope = 2
    end
    array = Song.where("songs.average_mood - ? <= ? or ? = 0", mood, scope, mood)
      .where("songs.average_mood - ? >= ? or ? = 0", mood, -scope, mood)
      .where("songs.average_timbre - ? <= ? or ? = 0", timbre, scope, timbre)
      .where("songs.average_timbre - ? >= ? or ? = 0", timbre, -scope, timbre)
      .where("songs.average_intensity - ? <= ? or ? = 0", intensity, scope, intensity)
      .where("songs.average_intensity - ? >= ? or ? = 0", intensity, -scope, intensity)
      .where("songs.average_tone - ? <= ? or ? = 0", tone, scope, tone)
      .where("songs.average_tone - ? >= ? or ? = 0", tone, -scope, tone)
      .pluck(:id)
    whitelist_array = []
    playlist.whitelist.each do |song|
      whitelist_array << song
    end
    blacklist_array = []
    playlist.blacklist.each do |song|
      blacklist_array << song
    end
    final_array = (playlist.whitelist + array) - (playlist.blacklist)
    last_check_of_presence(final_array, playlist, whitelist_array, blacklist_array)
  end

  def change_whitelist(playlist, song, action)
    if action == "add"
      whitelist_will_change!
      array = playlist.whitelist
      array << song.id
      playlist.update(:whitelist => array)
    elsif action == "remove"
      blacklist_will_change!
      array = playlist.blacklist
      array << song.id
      if playlist.whitelist.include? song.id
        whitelist_will_change!
        whitelist_array = playlist.whitelist
        whitelist_array.delete(song.id)
        playlist.update(:whitelist => whitelist_array)
      end
      playlist.update(:blacklist => array)
    elsif action == "unblacklist"
      blacklist_will_change!
      array = playlist.blacklist
      array.delete(song.id)
      playlist.update(:blacklist => array)
    elsif action == "unwhitelist"
      whitelist_will_change!
      array = playlist.whitelist
      array.delete(song.id)
      playlist.update(:whitelist => array)
    end
  end

private

  def last_check_of_presence(songs, playlist, original_whitelist, original_blacklist)
    songs_list_will_change!
    whitelist_will_change!
    blacklist_will_change!
    white_array = playlist.whitelist
    songs.each do |song|
      if Song.find_by_id(song).nil?
        songs.delete(song)
        white_array.delete(song)
        black_array.delete(song)
      end
    end
    playlist.blacklist.each do |song|
      if Song.find_by_id(song).nil?
        playlist.blacklist.delete(song)
      end
    end
    if white_array != original_whitelist
      playlist.update(:whitelist => white_array)
    end
    if playlist.blacklist != original_blacklist
      playlist.update(:blacklist => playlist.blacklist)
    end
    songs = songs.uniq.sort
    if playlist.songs_list != songs
      playlist.update(:songs_list => songs)
    end
  end

end
