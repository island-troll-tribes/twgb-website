class GamePlayer < ApplicationRecord
  self.table_name = 'gameplayers'

  belongs_to :game, foreign_key: 'gameid', inverse_of: :game_players
end
