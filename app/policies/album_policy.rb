class AlbumPolicy
  attr_reader :user, :album

  def initialize(user, album)
    @user = user
    @album = album
  end

  def new?
    user.admin? || (user.role == "band" && album.band_id == user.id)
  end

  def create?
    user.admin? || (user.role == "band" && album.band_id == user.id)
  end

  def edit?
    user.admin? || (user.role == "band" && album.band_id == user.id)
  end

  def update?
    user.admin? || (user.role == "band" && album.band_id == user.id)
  end

  def destroy?
    user.admin? || (user.role == "band" && album.band_id == user.id)
  end
end
