class SeasonsController < ApplicationController
    before_action :require_user
    before_action :set_current_league

    def index
        @seasons = Season.all 
    end
end
