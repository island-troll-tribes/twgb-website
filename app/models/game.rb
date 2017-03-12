class Game < ApplicationRecord
  has_many :game_players, class_name: 'GamePlayer', foreign_key: 'gameid', inverse_of: :game
  has_many :w3mmd_players, class_name: 'W3mmdPlayer', foreign_key: 'gameid', inverse_of: :game
  has_many :w3mmd_vars, class_name: 'W3mmdVar', foreign_key: 'gameid', inverse_of: :game
end
