class UserPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def edit?
    user.admin? || user.id == record.id
  end

  def update?
    user.admin? || user.id == record.id
  end

  def edit_profile?
    user.admin? || user.id == record.id
  end

  def update_profile?
    user.admin? || user.id == record.id
  end
end
