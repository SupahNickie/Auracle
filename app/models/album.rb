require 'mime/types'

class Album < ActiveRecord::Base
  belongs_to :band, class_name: "User"
  has_many :songs, dependent: :destroy
  accepts_nested_attributes_for :songs, allow_destroy: true
  has_attached_file :album_art, :styles => { :album_art => "700x700>" }
  do_not_validate_attachment_file_type :album_art

  def slug
    title.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

end
