class MembersController < ApplicationController
  before_action :require_user
  before_action :set_current_league

  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])
    games_constant = Game.where(home_id: @member.id)
                          .or(Game.where(away_id: @member.id))
                          .custom_filter(params.slice(:year), @member)
    @games = Game.where(home_id: @member.id)
                 .or(Game.where(away_id: @member.id))
                 .custom_filter(params.slice(:year, :week_number, :opposing_player, :game_type), @member)
                 .order(year: :desc)
                 .order(:week_number)
    win_loss_filter if params[:win_loss]
    @available_weeks = games_constant.distinct.pluck(:week_number)
    @game_opponents = opponent_builder(games_constant, @member)
    @avg_data = AverageGameData.new(@games, @member)
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to @member
    else
      render :new
    end
  end

  private

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :password)
  end

  def win_loss_filter
    if params[:win_loss] == "Win"
      @games = @games.where(winner_id: params[:viewed_member])
    elsif params[:win_loss] == "Loss"
      @games = @games.where(loser_id: params[:viewed_member])
    else
      @games
    end
  end

  def avg_score(games, member)
    total_score = []
    games.each do |game|
      total_score << game.my_score(member)
    end
    total_score.sum / total_score.size unless total_score.size.zero?
  end

  def opponent_avg_score(games, member)
    total_score = []
    games.each do |game|
      total_score << game.opponent_score(member)
    end
    total_score.sum / total_score.size unless total_score.size.zero?
  end

  def opponent_builder(games, member)
    opponents = []
    games.each do |game|
      opponents << game.opponent_member_object(member)
    end
    opponents.uniq
  end

  def filtering_params(params)
    params.slice(:year, :week_number, :opposing_player, :game_type)
  end
end
