class StandingsController < ApplicationController
  def index
    @categories = W3mmdEloScores.categories
  end

  def show
    @category = params[:name].downcase
    @page = [params[:page].to_i, 1].max
    @scores = W3mmdEloScore
      .ranked
      .where(category: @category)
      .order(score: :desc)
      .page(@page)
  end
end
