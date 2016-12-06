class GamePlayer < ApplicationRecord
  self.table_name = 'gameplayers'

  belongs_to :game, foreign_key: 'gameid'
  has_one :w3mmd_player, ->(gp) { where(pid: gp.colour) }, foreign_key: 'gameid'
end
