class League < ApplicationRecord
  has_many :seasons
  has_many :members
  has_many :member_seasons, through: :seasons
end
