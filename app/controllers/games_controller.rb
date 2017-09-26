class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def index
    get_category_and_date_range
    @names = username_list(params[:name])

    @games = Game
      .includes(:w3mmd_players)
      .preload(:w3mmd_vars)
      .where('datetime >= ?', @start_range)
      .where('datetime <= ?', @end_range)
      .order(id: :desc)
      .page(params[:page])
    @games = @games.where(w3mmdplayers: { category: params[:category] }) if @category.present?

    if @names.any?
      @names
        .map { |name| W3mmdPlayer.select(:gameid).where(name: name) }
        .each { |q| @games = @games.where(id: q) }
    end
  end

  def show
    @players = @game.w3mmd_players.order(:pid).load
  end

  def replay
    filename = params[:id] + '.w3g'
    send_file_from_twgb_host 'replays/', filename
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end
end
