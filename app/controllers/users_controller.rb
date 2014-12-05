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
    else
      render "new"
    end
  end

  def pick_deck
    current_user.update_columns(current_deck_id: params[:current_deck_id])
    redirect_to root_path, notice: "Current deck was picked"
  end

  private

  def users_params
    params.require(:user).permit(:email, :password, :password_confirmation, :authentications_attributes)
  end
end
