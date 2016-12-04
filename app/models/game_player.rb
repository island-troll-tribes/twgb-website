class GamePlayer < ApplicationRecord
  self.table_name = 'gameplayers'

  belongs_to :game, foreign_key: 'gameid'
end
