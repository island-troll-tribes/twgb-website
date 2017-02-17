class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  # GET /games
  # GET /games.json
  def index
    @games = Game.last(30).reverse
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end
end
