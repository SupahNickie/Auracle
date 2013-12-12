class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :albums
  has_many :playlists
  has_many :photo_albums
  has_attached_file :avatar, :styles => { :avatar => "200x200>" }
  has_attached_file :user_pic, :styles => { :user_pic => "700x500>" }

end
