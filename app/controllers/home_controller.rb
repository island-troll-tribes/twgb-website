class HomeController < ApplicationController
  def index
    @w3mmd_elo_scores = W3mmdEloScore.order(score: :desc).all
  end
end
