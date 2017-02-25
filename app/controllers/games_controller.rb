class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def index
    @games = Game.includes(:w3mmd_players).last(50).reverse
  end

  def show
  end

  def replay
    agent = Mechanize.new
    page = agent.get('https://www.lunaghost.com/panel/index.php')
    login = page.form
    login.email = config.lunaghost_email
    login.password = config.lunaghost_password
    agent.submit(login, login.buttons.first)
    data = agent.get_file("http://ny1.lunaghost.com/panel/ghost/replay.php?id=695&action=download&replay=#{params[:id]}.w3g")
    send_data data, filename: params[:id] + '.w3g', type: "application/octet-stream", disposition: 'inline', stream: 'true'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end
end
