class SeasonsController < ApplicationController
    before_action :require_user

    def index
        @seasons = Season.all 
    end
end
