class UsersController < ApplicationController
  before_action :require_user

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @games_constant = Game.where(home_id: @user.id).or(Game.where(away_id: @user.id)).filter(params.slice(:year), @user)
    @games = Game.where(home_id: @user.id).or(Game.where(away_id: @user.id)).filter(params.slice(:year, :week_number, :opposing_player, :game_type), @user).order(:year, :week_number)
    win_loss_filter if params[:win_loss]
    @available_weeks = weeks_builder(@games_constant)
    @game_opponents = opponent_builder(@games_constant, @user)
    @wins = @games.where(winner_id: @user.id).size
    @losses = @games.where(loser_id: @user.id).size
    @win_loss = (@wins.to_f / (@wins.to_f + @losses.to_f)).round(4)
    @avg_score = avg_score(@games, @user).to_f.round(2)
    @avg_opponent_score = opponent_avg_score(@games, @user).to_f.round(2)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def win_loss_filter
    if params[:win_loss] == "Win"
      @games = @games.where(winner_id: params[:viewed_user])
    elsif params[:win_loss] == "Loss"
      @games = @games.where(loser_id: params[:viewed_user])
    else
      @games
    end
  end

  def weeks_builder(games)
    weeks = []
    games.each { |game| weeks << game.week_number }
    weeks.uniq
  end

  def avg_score(games, user)
    total_score = []
    games.each do |game|
      total_score << game.my_score(user)
    end
    total_score.sum / total_score.size unless total_score.size.zero?
  end

  def opponent_avg_score(games, user)
    total_score = []
    games.each do |game|
      total_score << game.opponent_score(user)
    end
    total_score.sum / total_score.size unless total_score.size.zero?
  end

  def opponent_builder(games, user)
    opponents = []
    games.each do |game|
      opponents << game.opponent_user_object(user)
    end
    opponents.uniq
  end

  def filtering_params(params)
    params.slice(:year, :week_number, :opposing_player, :game_type)
  end
end
