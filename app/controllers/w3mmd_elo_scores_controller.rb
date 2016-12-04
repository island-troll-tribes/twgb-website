class W3mmdEloScoresController < ApplicationController
  before_action :set_w3mmd_elo_score, only: [:show]

  # GET /w3mmd_elo_scores
  # GET /w3mmd_elo_scores.json
  def index
    @w3mmd_elo_scores = W3mmdEloScore.all
  end

  # GET /w3mmd_elo_scores/1
  # GET /w3mmd_elo_scores/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_w3mmd_elo_score
      @w3mmd_elo_score = W3mmdEloScore.find(params[:id])
    end
end
