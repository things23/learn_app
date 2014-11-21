class UsersController < ApplicationController
  before_action :require_login, only: [:index]
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: "User was successfully created."
    end
  end

  private

  def users_params
    params.require(:user).permit(:email, :password, :password_confirmation, :authentications_attributes)
  end
end
