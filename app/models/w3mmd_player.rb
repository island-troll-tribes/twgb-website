class W3mmdPlayer < ApplicationRecord
  self.table_name = 'w3mmdplayers'

  belongs_to :game, foreign_key: :gameid
  has_many :w3mmd_vars, through: :game

  def troll_class
    var = get_w3mmd_var('class', :value_string)
    if var.present?
      var[1...-1].split('_').drop(1).map(&:titleize).join(' ')
    end
  end

  def get_w3mmd_var(name, field)
    w3mmd_vars.inject nil do |memo, var|
      if var.pid == self.pid and var.varname == name
        var[field]
      else
        memo
      end
    end
  end
end
