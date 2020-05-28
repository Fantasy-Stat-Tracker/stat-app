class LeaguesController < ApplicationController

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    if @league.save
      redirect_to @league
    else
      render :new
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :start_year, :source, :espn_s2, :swid)
  end
end
