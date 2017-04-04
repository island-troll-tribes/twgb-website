json.extract! game, :id, :botid, :server, :map, :datetime, :gamename, :ownername, :duration, :datetime
json.players game.w3mmd_players, partial: 'games/player', as: :player
json.url game_url(game, format: :json)
