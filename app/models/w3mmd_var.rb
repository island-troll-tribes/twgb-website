class W3mmdVar < ApplicationRecord
  self.table_name = 'w3mmdvars'

  include ParseTrollClass

  belongs_to :game, foreign_key: :gameid, inverse_of: :w3mmd_vars

  def as_troll_class
    parse_troll_class(value_string)
  end
end
