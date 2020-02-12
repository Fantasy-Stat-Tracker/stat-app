class League < ApplicationRecord
  has_many :seasons
  has_many :members
end
