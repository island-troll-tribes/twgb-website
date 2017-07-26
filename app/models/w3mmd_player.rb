class W3mmdPlayer < ApplicationRecord
  self.table_name = 'w3mmdplayers'

  belongs_to :game, foreign_key: :gameid, inverse_of: :w3mmd_players

  def troll_class
    get_w3mmd_var('class').try(:as_troll_class)
  end

  def random_class
    !!get_w3mmd_var_field('random', :value_int)
  end

  def kills
    get_w3mmd_var_field('kills', :value_int)
  end

  def deaths
    get_w3mmd_var_field('deaths', :value_int)
  end

  def gold
    get_w3mmd_var_field('gold', :value_int)
  end

  def get_w3mmd_var(name)
    game.w3mmd_vars.inject nil do |memo, var|
      if var.pid == pid and var.varname == name
        var
      else
        memo
      end
    end
  end

  def get_w3mmd_var_field(name, field)
    get_w3mmd_var(name).try(field)
  end

  def opponents
    game.w3mmd_players.select do |p|
      p.flag and (p.flag != flag or (flag == 'drawer' and p.pid != pid))
    end
  end

  def allies
    game.w3mmd_players.select do |p|
      p.flag == flag and p.pid != pid
    end
  end
end
