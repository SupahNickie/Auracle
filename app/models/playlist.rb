class Playlist < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  validates :mood, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, on: :create
  validates :timbre, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, on: :create
  validates :intensity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, on: :create
  validates :tone, :numericality => { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, on: :create
  validates :scope, presence: true, on: :create

  def slug
    name.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

  def find_music(playlist, mood, timbre, intensity, tone, scope, sorted)
    case scope
    when "expansive" then scope = 8
    when "loose" then scope = 5
    when "strict" then scope = 2
    end
    if sorted == "order" # use caching to just view current playlist without regenerating it if possible
      begin
        playlist.songs_list = Rails.cache.fetch("#{playlist.id}-found_music").sort_by {|x| [x.album.band.username, x.album.title]}
        if playlist.songs_list.empty?
          Rails.cache.write("#{playlist.id}-found_music", result = query_database(playlist, mood, timbre, intensity, tone, scope))
          playlist.songs_list = Rails.cache.fetch("#{playlist.id}-found_music").sort_by {|x| [x.album.band.username, x.album.title]}
        end
      rescue
        Rails.cache.write("#{playlist.id}-found_music", result = query_database(playlist, mood, timbre, intensity, tone, scope))
        playlist.songs_list = Rails.cache.fetch("#{playlist.id}-found_music").sort_by {|x| [x.album.band.username, x.album.title]}
      end
    else # Generate playlist from scratch for playback
      Rails.cache.write("#{playlist.id}-found_music", result = query_database(playlist, mood, timbre, intensity, tone, scope))
      playlist.songs_list = Rails.cache.fetch("#{playlist.id}-found_music").shuffle
    end
  end

  def change_whitelist(playlist, song, action)
    case action
    when "add"
      whitelist_will_change!
      array = playlist.whitelist
      array << song.id
      playlist.update(whitelist: array)
    when "remove"
      blacklist_will_change!
      array = playlist.blacklist
      array << song.id
      if playlist.whitelist.include? song.id
        whitelist_will_change!
        whitelist_array = playlist.whitelist
        whitelist_array.delete(song.id)
        playlist.update(whitelist: whitelist_array)
      end
      playlist.update(blacklist: array)
    when "unblacklist"
      blacklist_will_change!
      array = playlist.blacklist
      array.delete(song.id)
      playlist.update(blacklist: array)
    when "unwhitelist"
      whitelist_will_change!
      array = playlist.whitelist
      array.delete(song.id)
      playlist.update(whitelist: array)
    end
  end

private

  def query_database(playlist, mood, timbre, intensity, tone, scope)
    results = Song.find_by_sql ["SELECT songs.* FROM songs WHERE
      (songs.id IN (:whitelist)) OR
      (songs.id NOT IN (:blacklist) AND
      (songs.average_mood - :mood <= :scope OR :mood = 0) AND
      (songs.average_mood - :mood >= -:scope OR :mood = 0) AND
      (songs.average_timbre - :timbre <= :scope OR :timbre = 0) AND
      (songs.average_timbre - :timbre >= -:scope OR :timbre = 0) AND
      (songs.average_intensity - :intensity <= :scope OR :intensity = 0) AND
      (songs.average_intensity - :intensity >= -:scope OR :intensity = 0) AND
      (songs.average_tone - :tone <= :scope OR :tone = 0) AND
      (songs.average_tone - :tone >= -:scope OR :tone = 0))",
      {whitelist: playlist.whitelist, blacklist: playlist.blacklist,
      scope: scope, mood: mood, timbre: timbre, intensity: intensity, tone: tone}]
    ActiveRecord::Associations::Preloader.new.preload(results, [album: :band])
    results
  end

end
