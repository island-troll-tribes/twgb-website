class ClassesController < ApplicationController
  before_action :get_params

  def index
    get_category_and_date_range
    get_top_player_by_class
  end

  def show
    get_category_and_date_range
    query = get_players_ranked_by_class(params[:class])

    @players = ApplicationRecord
      .connection
      .select_all(query)
      .to_hash
  end

  private

  def get_params
    @name = params[:name]
    min_games = params[:minimum_games]
    @min_games = if min_games.present? then
                  min_games.to_i
                else
                  W3mmdEloScore::RANKED_GAMES_THRESHOLD
                end
  end

  def get_players_ranked_by_class(klass=nil)
    player_wins_and_losses_by_class = Game
      .select(
        'name',
        'value_string',
        'SUM(CASE WHEN flag = "winner" THEN 1 ELSE 0 END) AS wins',
        'SUM(CASE WHEN flag = "loser" THEN 1 ELSE 0 END) AS losses',
        'SUM(elochange) AS elo',
      )
      .joins(:w3mmd_players)
      .joins("INNER JOIN w3mmdvars AS v ON v.gameid = games.id AND v.pid = w3mmdplayers.pid")
      .where('varname = "class"')
      .where('datetime >= ?', @start_range)
      .where('datetime <= ?', @end_range)
      .where.not('v.value_string = "\"\""')
      .where.not('flag = ""')
      .group('name', 'value_string')
      .having('wins + losses >= ?', @min_games)
    player_wins_and_losses_by_class = player_wins_and_losses_by_class
      .where(w3mmdplayers: { category: @category }) if @category.present?
    player_wins_and_losses_by_class = player_wins_and_losses_by_class
      .where(w3mmdplayers: { name: @name }) if @name.present?
    player_wins_and_losses_by_class = player_wins_and_losses_by_class
      .where('v.value_string = ?', "\"UNIT_#{klass.upcase.gsub(/ /, '_')}\"") if klass.present?

    %Q{
      SELECT
          name,
          value_string AS class,
          wins,
          losses,
          elo,
          wins * 100.0 / (losses + wins) AS percent,
          elo * wins / (losses + wins) AS score
      FROM (#{player_wins_and_losses_by_class.to_sql}) AS a
      ORDER BY score DESC, percent DESC, wins DESC, name ASC
    }
  end

  def get_top_player_by_class
    query = %Q{
      SELECT * FROM (#{get_players_ranked_by_class}) AS b
      GROUP BY class
    }

    p query 
    @top_ranking_player_by_class = ApplicationRecord
      .connection
      .select_all(query)
      .to_hash
  end
end
