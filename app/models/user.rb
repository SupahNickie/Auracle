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
  validates :role, presence: true

  def push_song_id_to_ratings_list(song, user)
    @song = song
    @user = user
    ratings_will_change!
    new_ratings_list = @user.ratings << @song.id
    @user.update(:ratings => new_ratings_list)
  end

  def add_song_to_favorites(song, user)
    @song = song
    @user = user
    favorites_will_change!
    array = @user.favorites
    array << @song.id
    @user.update(:favorites => array)
  end

end
