class PlayersController < ApplicationController
  def show
    @category = params[:category_name]
    @name = params[:name].downcase

    @record = W3mmdEloScore.where(name: @name, category: @category).first

    if @category.include? '1v1'
      show_1v1
      return
    end

    @games = W3mmdPlayer
      .includes(:game)
      .where(name: @name, category: @category)
      .where.not(flag: '')
      .order(id: :desc)
  end

  def show_1v1
    @games = W3mmdPlayer
      .where(name: @name, category: @category)
      .where.not(flag: '')
      .includes(game: [:w3mmd_players, :w3mmd_vars])
      .order(id: :desc)

      render 'show_1v1'
  end
end
