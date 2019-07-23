class Season < ApplicationRecord
    has_many :weeks
    has_many :user_seasons
    has_many :users, through: :user_seasons
end
