class HomeController < ApplicationController
  def home
    @user = current_user
  end

  def about
  end
end
