class W3mmdVar < ApplicationRecord
  self.table_name = 'w3mmdvars'

  belongs_to :game, foreign_key: :gameid, inverse_of: :w3mmd_vars
end
