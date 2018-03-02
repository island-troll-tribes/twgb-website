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

  def rollback_elo
    W3mmdPlayer.transaction do
      w3mmd_players.each do |player|
        if player.elochange.present?
          score = W3mmdEloScore.where(name: player.name, category: player.category).first
          if player.flag == 'winner'
            score.decrement(:wins)
          elsif player.flag == 'loser'
            score.decrement(:losses)
          end
          score.decrement(:games)
          score.decrement(:score, player.elochange)
          score.save!
          player.update!(elochange: nil)
        end
      end
    end
  end

  def recalculate_elo
    self.class.transaction do
      games.where('id >= ?', id).each do |game|
        game.rollback_elo
      end

      W3mmdEloGamesScored.where('gameid >= ?', id).destroy_all
    end
  end
end
