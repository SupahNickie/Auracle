require 'mime/types'

class Album < ActiveRecord::Base
  belongs_to :band, class_name: "User"
  has_many :songs, dependent: :destroy
  accepts_nested_attributes_for :songs, allow_destroy: true
  has_attached_file :album_art, :styles => { :album_art => "700x700>" }
  validates :title, presence: true
  validates_attachment :album_art,
                        presence: true,
                        content_type: { content_type: ["image/jpeg", "image/png"] },
                        size: { in: 0..5.megabytes }

  def slug
    title.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

end
