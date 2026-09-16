class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].to_s.strip.downcase
    @user = User.find_by("LOWER(email) = ?", email)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:success] = @user.first_name.present? ? "Welcome, #{@user.first_name}." : "Welcome back!"
      if current_member
        set_current_league
        redirect_to league_games_url(@league_id)
      else
        redirect_to users_path
      end
    else
      flash[:danger] = "Incorrect credentials. Please try again."
      redirect_to :root
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
