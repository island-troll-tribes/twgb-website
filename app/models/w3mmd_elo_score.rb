class W3mmdEloScore < ApplicationRecord
  def percent
    wins * 100.0 / (losses + wins)
  end
end
