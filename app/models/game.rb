class Game < ApplicationRecord
  has_many :game_players, foreign_key: 'gameid'
end
