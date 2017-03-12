class W3mmdPlayer < ApplicationRecord
  self.table_name = 'w3mmdplayers'

  belongs_to :game, foreign_key: :gameid, inverse_of: :w3mmd_players

  def troll_class
    var = get_w3mmd_var('class', :value_string)
    if var.present?
      var[1...-1].split('_').drop(1).map(&:titleize).join(' ')
    end
  end

  def random_class
    !!get_w3mmd_var('random', :value_int)
  end

  def kills
    get_w3mmd_var('kills', :value_int)
  end

  def deaths
    get_w3mmd_var('deaths', :value_int)
  end

  def gold
    get_w3mmd_var('gold', :value_int)
  end

  def get_w3mmd_var(name, field)
    game.w3mmd_vars.inject nil do |memo, var|
      if var.pid == pid and var.varname == name
        var[field]
      else
        memo
      end
    end
  end

  def opponents
    game.w3mmd_players.select do |p|
      p.flag and (p.flag != flag or flag == 'drawer')
    end
  end

  def allies
    game.w3mmd_players.select do |p|
      p.flag == flag and p.pid != pid
    end
  end
end
