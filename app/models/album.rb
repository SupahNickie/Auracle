require 'mime/types'

class Album < ActiveRecord::Base
  belongs_to :band, class_name: "User"
  has_many :songs, dependent: :destroy
  has_many :playlists, through: :songs
  accepts_nested_attributes_for :songs, allow_destroy: true
  has_attached_file :album_art, :styles => { :album_art => "700x700>" }

end
