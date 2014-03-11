class UserPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def edit_profile?
    user.admin?
  end

  def update_profile?
    user.admin?
  end
end
