class PlayersController < ApplicationController
	def show
    @name = params[:name]
		@records = W3mmdEloScore.where(name: @name).order(:category)
	end
end
