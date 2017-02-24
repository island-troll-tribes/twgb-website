class CategoriesController < ApplicationController
  def show
    @category = params[:name].downcase
    @w3mmd_elo_scores = W3mmdEloScore.where(category: @category).order(score: :desc).all
  end
end
