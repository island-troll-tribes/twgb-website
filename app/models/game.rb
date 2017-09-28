class Game < ApplicationRecord
  has_many :game_players, class_name: 'GamePlayer', foreign_key: 'gameid', inverse_of: :game
  has_many :w3mmd_players, class_name: 'W3mmdPlayer', foreign_key: 'gameid', inverse_of: :game
  has_many :w3mmd_vars, class_name: 'W3mmdVar', foreign_key: 'gameid', inverse_of: :game

  def players(flag)
    w3mmd_players.select { |p| p.flag == flag }
  end

  def winners
    players('winner')
  end

  def losers
    players('loser')
  end

  def drawers
    players('drawer')
  end

  def elo_change
    w3mmd_players.first.try(:elochange).try(:abs)
  end

  def self.average_game_length(&blk)
    query = self
      .select(
        'AVG(duration) / 60 AS average',
        'DATE_FORMAT(datetime, "%Y-%m-%d 00:00:00 UTC") AS date_slice',
      )
      .where('duration > ?', 8.minutes.seconds)
      .group('date_slice')
      .order('date_slice')

    query = yield query if blk

    return query
  end
end
