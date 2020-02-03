class SeasonsController < ApplicationController
    before_action :require_member

    def index
        @seasons = Season.all 
    end
end
