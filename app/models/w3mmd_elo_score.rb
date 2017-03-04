class W3mmdEloScore < ApplicationRecord
  def percent
    wins * 100.0 / games
  end
end
