class Game < ApplicationRecord
  belongs_to :week
  has_many :users
end
