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
    @games = W3mmdPlayer.
      connection.
      select_all(%Q(
           SELECT
             p1.gameid gameid,
             p1.flag result,
             p1.elochange elochange,
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
             p1.category = '#{@category}'
           ORDER BY
             p1.gameid DESC
      )).to_hash

      render 'show_1v1'
  end
end
