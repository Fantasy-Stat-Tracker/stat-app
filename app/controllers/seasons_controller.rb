class SeasonsController < ApplicationController
  include Filterable
  before_action :require_user
  before_action :set_current_league
  before_action :set_filter_data

  def index
    @league = League.find(@league_id)
    @filtered_season = params[:season] || @league.seasons.order("year DESC").first
    @member_seasons = @league.member_seasons.where(season_id: @filtered_season.id).order("win_percentage DESC")
  end

  def show
    season = Season.find(params[:year])
    @member_seasons = season.member_seasons.order("win_percentage DESC")

    if turbo_frame_request?
      puts "this was a turbo frame request"
    end

    render partial: "show", locals: { member_seasons: @member_seasons }
  end

  private

  def set_filter_data
    league = League.find(@league_id)
    @filter_data = league.seasons.pluck(:year, :id).sort.reverse
  end
end
