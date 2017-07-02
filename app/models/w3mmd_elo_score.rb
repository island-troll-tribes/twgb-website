class W3mmdEloScore < ApplicationRecord
  default_scope { where.not(category: ['ITT-latest', 'pro']) }

  def percent
    wins * 100.0 / games
  end

  def rank
    self.class
      .where(category: category)
      .where("score > ?", score)
      .count + 1
  end

  def self.categories
    select(:category).distinct.pluck(:category)
  end
end
