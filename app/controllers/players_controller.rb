class PlayersController < ApplicationController
  def show
    @name = params[:name].downcase

    @elo = W3mmdEloScore.where(name: @name, category: '2016_1v1_league').first.score

    @record = W3mmdPlayer.
      where(name: @name, category: '2016_1v1_league').
      group('flag').
      count

    @games = W3mmdPlayer.
      connection.
      select_all(%Q(
           SELECT
             p1.gameid gameid,
             p1.flag result,
             c1.value_string p1_class,
             r1.value_int p1_random,
             p2.name opponent,
             c2.value_string p2_class,
             r2.value_int p2_random
           FROM w3mmdplayers p1
           INNER JOIN w3mmdplayers p2 ON
             p1.gameid = p2.gameid AND
             p1.flag != p2.flag
           LEFT JOIN w3mmdvars c1 ON
             p1.gameid = c1.gameid AND
             p1.pid = c1.pid AND
             c1.varname = 'class' AND
             c1.value_string != '""'
           LEFT JOIN w3mmdvars c2 ON
             p2.gameid = c2.gameid AND
             p2.pid = c2.pid AND
             c2.varname = 'class' AND
             c2.value_string != '""'
           LEFT JOIN w3mmdvars r1 ON
             p1.gameid = r1.gameid AND
             p1.pid = r1.pid
             AND r1.varname = 'random'
           LEFT JOIN w3mmdvars r2 ON
             p2.gameid = r2.gameid AND
             p2.pid = r2.pid AND
             r2.varname = 'random'
           WHERE
             p1.name = '#{@name}' AND
             p1.category = '2016_1v1_league'
           ORDER BY
             p1.gameid DESC
      )).to_hash
  end
end
