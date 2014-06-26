class HomeController < ApplicationController
  def home
    @user = (current_user || guest_user)
  end

  def about
  end
end
