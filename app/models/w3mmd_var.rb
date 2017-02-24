class W3mmdVar < ApplicationRecord
  self.table_name = 'w3mmdvars'

  has_many :w3mmd_player, foreign_key: :gameid
end
