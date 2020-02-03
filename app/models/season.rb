class Season < ApplicationRecord
    has_many :weeks
    has_many :games, through: :weeks
    has_many :member_seasons
    has_many :members, through: :member_seasons

    def find_winner(season)
        member = season.member_seasons.find_by(is_winner:true)&.member_id
        Member.find(member).full_name if member
    end
end
