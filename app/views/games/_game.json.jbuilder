json.extract! game, :id, :botid, :server, :map, :datetime, :gamename, :ownername, :duration, :gamestate, :creatorname, :creatorserver, :created_at, :updated_at
json.url game_url(game, format: :json)