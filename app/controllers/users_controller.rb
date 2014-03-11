class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.where(role: "band")
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Your artist profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def profile
    @user = current_user
  end

  def edit_profile
    @user = current_user
    authorize @user
  end

  def update_profile
    @user = current_user
    authorize @user

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_user_path(@user), notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_profile' }
        format.json {render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :avatar, :user_pic, :role, :ratings)
    end

end
