class AlbumPolicy
  attr_reader :user, :album

  def initialize(user, album)
    @user = user
    @album = album
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
