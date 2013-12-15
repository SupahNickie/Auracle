json.array!(@playlists) do |playlist|
  json.extract! playlist, :id, :name, :mood, :timbre, :intensity, :tone
  json.url playlist_url(playlist, format: :json)
end
