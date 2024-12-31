# frozen_string_literal: true

# Controller for creating users
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(league_params)
    if @league.save
      redirect_to @league
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
