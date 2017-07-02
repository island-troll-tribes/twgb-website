class W3mmdVar < ApplicationRecord
  self.table_name = 'w3mmdvars'

  belongs_to :game, foreign_key: :gameid, inverse_of: :w3mmd_vars

  def as_troll_class
    value_string[1...-1].split('_').drop(1).map(&:titleize).join(' ')
  end
end
