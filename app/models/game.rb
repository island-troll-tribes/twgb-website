class Game < ApplicationRecord
  has_many :game_players, foreign_key: 'gameid'
  has_many :w3mmd_players, class_name: 'W3mmdPlayer', foreign_key: 'gameid'
  has_many :w3mmd_vars, class_name: 'W3mmdVar', foreign_key: 'gameid'
end
