json.array!(@songs) do |song|
  json.extract! song, :id, :title, :link_to_purchase, :link_to_download
  json.url song_url(song, format: :json)
end
