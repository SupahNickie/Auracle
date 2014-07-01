class SongPolicy
  attr_reader :user, :song

  def initialize(user, song)
    @user = user
    @song = song
  end

  def new?
    user.admin? || (song.album.band_id == user.id)
  end

  def create?
    user.admin? || (song.album.band_id == user.id)
  end

  def edit?
    user.admin? || (song.album.band_id == user.id)
  end

  def update?
    user.admin? || (song.album.band_id == user.id)
  end

  def destroy?
    user.admin? || (song.album.band_id == user.id)
  end

  def rating?
    user.admin? || (user.ratings.exclude?(song.id))
  end

  def vote?
    user.admin? || (user.ratings.exclude?(song.id))
  end
end
