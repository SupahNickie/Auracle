  class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :albums, foreign_key: "band_id"
  has_many :songs, through: :albums
  has_many :playlists
  has_attached_file :avatar, :styles => { :avatar => "200x200>" }
  has_attached_file :user_pic, :styles => { :user_pic => "700x500>" }
  validates :role, presence: true

  def slug
    username.downcase.gsub(" ", "-")
    username.gsub(".", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

  def push_song_id_to_ratings_list(song, user)
    @song = song
    @user = user
    ratings_will_change!
    new_ratings_list = @user.ratings << @song.id
    @user.update(:ratings => new_ratings_list)
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      if auth.provider == "google_oauth2"
        user.username = auth.info.name
        user.email = auth.info.email
      else
        user.username = auth.info.nickname
        user.email = "#{user.username}-CHANGEME@#{auth.provider}.com"
      end
      user.role = "personal"
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.nil?
  end

  def update_with_password(params, *options)
    if encrypted_password.nil?
      update_attributes(params, *options)
    else
      super
    end
  end
end
