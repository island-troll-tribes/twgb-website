class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def index
    @games = Game.includes(:w3mmd_players, :w3mmd_vars).last(50).reverse
  end

  def show
    @players = @game.w3mmd_players.order(:pid).load
  end

  def replay
    agent = Mechanize.new
    page = agent.get('https://www.lunaghost.com/panel/index.php')
    login = page.form
    login.email = Rails.application.config.lunaghost_email
    login.password = Rails.application.config.lunaghost_password
    agent.submit(login, login.buttons.first)
    agent.page.links[3].click
    agent.page.links.last.click
    data = agent.get_file("http://ny1.lunaghost.com/panel/ghost/replay.php?id=695&action=download&replay=#{params[:id]}.w3g")

    if data.empty?
      raise ActionController::RoutingError.new('Replay expired')
    else
      send_data data, filename: params[:id] + '.w3g', disposition: :attachment
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end
end
