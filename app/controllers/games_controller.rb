class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def index
    @games = Game.includes(:w3mmd_players, :w3mmd_vars).last(50).reverse
  end

  def show
    @players = @game.w3mmd_players.order(:pid).load
  end

  def replay
    hostname = Rails.application.config.twgb_host_hostname
    username = Rails.application.config.twgb_host_username
    pathname = Rails.application.config.twgb_host_pathname
    ssh_key = Rails.application.config.twgb_host_ssh_key

    filename = params[:id] + '.w3g'
    full_pathname = pathname + filename
    data = nil

    begin
      Net::SCP.start hostname, username, key_data: [ssh_key], keys_only: true do |scp|
        data = scp.download! full_pathname
      end
    rescue Net::SCP::Error => e
      if e.message.include? 'No such file or directory'
        raise ActionController::RoutingError.new('Replay expired')
      end
      raise e
    end

    send_data data, filename: filename, disposition: :attachment
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end
end
