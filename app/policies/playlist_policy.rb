class PlaylistPolicy
  attr_reader :user, :playlist

  def initialize(user, playlist)
    @user = user
    @playlist = playlist
  end

  def index?
    user.admin? || (user.role == "band" || user.role == "personal")
  end

  def new?
    user.admin? || (playlist.user_id == user.id)
  end

  def show?
    playlist.invisible ? user.admin? || (playlist.user_id == user.id) : true
  end

  def create?
    user.admin? || (playlist.user_id == user.id)
  end

  def edit?
    user.admin? || (playlist.user_id == user.id)
  end

  def update?
    user.admin? || (playlist.user_id == user.id)
  end

  def destroy?
    user.admin? || (playlist.user_id == user.id)
  end

  def whitelist?
    user.admin? || (playlist.user_id == user.id)
  end

  def blacklist?
    user.admin? || (playlist.user_id == user.id)
  end

  def unwhitelist?
    user.admin? || (playlist.user_id == user.id)
  end

  def unblacklist?
    user.admin? || (playlist.user_id == user.id)
  end

  def view_blacklist?
    user.admin? || (playlist.user_id == user.id)
  end
end
