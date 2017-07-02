class GameListController < ApplicationController
  def index
    @games = GameList.all
  end
end

