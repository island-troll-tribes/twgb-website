class PlayersController < ApplicationController
  def show
    @name = params[:name]
    @category = params[:category]

    @scores = W3mmdEloScore.where(name: @name).order(:category)

    @games = Game
      .includes(:w3mmd_players)
      .preload(:w3mmd_vars)
      .where(id: W3mmdPlayer.select(:gameid).where(name: @name))
      .order(id: :desc)
      .page(params[:page])
    @games = @games.where(w3mmdplayers: { category: @category }) if @category.present?

    classes = W3mmdVar
      .select('value_string', 'count(*) AS count')
      .joins('INNER JOIN `w3mmdplayers` AS `wp` ON `w3mmdvars`.`gameid` = `wp`.`gameid` AND `w3mmdvars`.`pid` = `wp`.`pid`')
      .where(varname: 'class')
      .where.not(value_string: '""')
      .where('name = ?', @name)
      .group('name, value_string')
    classes = classes.where('category = ?', @category) if @category.present?

    @classes = classes.reduce({}) do |memo, obj|
      memo.merge({ obj.as_troll_class => obj.count })
    end
  end

  def index
    @name = params[:name]
    return redirect_to player_path(@name) if @name
  end
end
