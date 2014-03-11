class SongPolicy
  attr_reader :user, :song

  def initialize(user, song)
    @user = user
    @song = song
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
