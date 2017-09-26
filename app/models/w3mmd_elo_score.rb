class W3mmdEloScore < ApplicationRecord
  RANKED_GAMES_THRESHOLD = 10

  default_scope { where.not(category: ['ITT-latest', 'pro']) }
  scope :ranked, -> { where('wins + losses >= ?', RANKED_GAMES_THRESHOLD) }

  def percent
    wins * 100.0 / (wins + losses)
  end

  def rank
    return 0 if wins + losses < RANKED_GAMES_THRESHOLD

    self.class
      .ranked
      .where(category: category)
      .where("score > ?", score)
      .count + 1
  end

  def self.categories
    select(:category).distinct.pluck(:category)
  end
end
