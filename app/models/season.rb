class Season < ApplicationRecord
    has_many :weeks
    has_many :games, through: :weeks
    has_many :user_seasons
    has_many :users, through: :user_seasons

    def find_winner(season)
        user = season.user_seasons.find_by(is_winner:true).user_id
        User.find(user).full_name
    end
end
