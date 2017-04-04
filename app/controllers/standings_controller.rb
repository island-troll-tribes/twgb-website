class StandingsController < ApplicationController
	def index
    @categories = W3mmdPlayer.select(:category).distinct.pluck(:category)
	end

  def show
    @category = params[:name].downcase
    @w3mmd_elo_scores = W3mmdEloScore.where(category: @category).order(score: :desc)
  end
end
