class Playlist < ActiveRecord::Base
  belongs_to :user

  def slug
    name.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

  def find_music(playlist, mood, timbre, intensity, tone, scope)
    songs_list_will_change!
    case scope
    when "expansive" then scope = 8
    when "loose" then scope = 5
    when "strict" then scope = 2
    end
    playlist.blacklist.size > 0 ? found_music = blacklist_query(playlist, mood, timbre, intensity, tone, scope) : found_music = empty_blacklist_query(playlist, mood, timbre, intensity, tone, scope)
    playlist.songs_list = found_music
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

  def blacklist_query(playlist, mood, timbre, intensity, tone, scope)
    Song.where("songs.average_mood - ? <= ? or ? = 0", mood, scope, mood)
    .where("songs.average_mood - ? >= ? or ? = 0", mood, -scope, mood)
    .where("songs.average_timbre - ? <= ? or ? = 0", timbre, scope, timbre)
    .where("songs.average_timbre - ? >= ? or ? = 0", timbre, -scope, timbre)
    .where("songs.average_intensity - ? <= ? or ? = 0", intensity, scope, intensity)
    .where("songs.average_intensity - ? >= ? or ? = 0", intensity, -scope, intensity)
    .where("songs.average_tone - ? <= ? or ? = 0", tone, scope, tone)
    .where("songs.average_tone - ? >= ? or ? = 0 or songs.id in (?)", tone, -scope, tone, playlist.whitelist)
    .where("songs.id not in (?)", playlist.blacklist)
    .includes(album: :band)
    .shuffle
  end

  def empty_blacklist_query(playlist, mood, timbre, intensity, tone, scope)
    Song.where("songs.average_mood - ? <= ? or ? = 0", mood, scope, mood)
    .where("songs.average_mood - ? >= ? or ? = 0", mood, -scope, mood)
    .where("songs.average_timbre - ? <= ? or ? = 0", timbre, scope, timbre)
    .where("songs.average_timbre - ? >= ? or ? = 0", timbre, -scope, timbre)
    .where("songs.average_intensity - ? <= ? or ? = 0", intensity, scope, intensity)
    .where("songs.average_intensity - ? >= ? or ? = 0", intensity, -scope, intensity)
    .where("songs.average_tone - ? <= ? or ? = 0", tone, scope, tone)
    .where("songs.average_tone - ? >= ? or ? = 0 or songs.id in (?)", tone, -scope, tone, playlist.whitelist)
    .includes(album: :band)
    .shuffle
  end

end
