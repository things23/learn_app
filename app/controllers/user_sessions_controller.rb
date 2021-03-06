class UserSessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user_sessions][:email], params[:user_sessions][:password])
      redirect_back_or_to root_path, notice: "Login successful"
    else
      flash.now[:alert] = "Login failed"
      render "new"
    end
  end

  def destroy
    logout
    redirect_to :login, notice: "Logged out!"
  end
end
