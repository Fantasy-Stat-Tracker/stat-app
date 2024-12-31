# frozen_string_literal: true

# This controls the Champions Club page
class ChampionsClubController < ApplicationController
  before_action :require_user
  before_action :set_current_league

  def index
    seasons = MemberSeason.where(is_winner: true)
    grouped_seasons = seasons.group_by(&:member_id)
    @winning_members = seasons.map(&:member_id).uniq
    @champ_seasons = grouped_seasons.sort_by { |_, v| v.count }.reverse.to_h
  end
end
