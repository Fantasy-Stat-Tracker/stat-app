class UserSeason < ApplicationRecord
  belongs_to :user
  belongs_to :season
end