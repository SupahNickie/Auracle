class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :albums, foreign_key: "band_id"
  has_many :playlists
  has_many :photo_albums
  has_attached_file :avatar, :styles => { :avatar => "200x200>" }
  has_attached_file :user_pic, :styles => { :user_pic => "700x500>" }
  validates :role, presence: true

  def push_song_id_to_ratings_list(song, user)
    @song = song
    @user = user
    ratings_will_change!
    new_ratings_list = @user.ratings << @song.id
    @user.update(:ratings => new_ratings_list)
  end

end
