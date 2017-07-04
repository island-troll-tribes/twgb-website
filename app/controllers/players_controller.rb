class PlayersController < ApplicationController
  def show
    @name = params[:name]
    @allies_text = params[:allies]
    @allies = username_list(@allies_text)
    @enemies_text = params[:enemies]
    @enemies = username_list(@enemies_text)
    @category = params[:category]
    @period = params[:period] || :week
    @start_range = params[:start_range] ? Date.strptime(params[:start_range], '%m/%d/%Y') : Date.new(2016, 10, 1)
    @end_range = params[:end_range] ? Date.strptime(params[:end_range], '%m/%d/%Y') : Date.tomorrow

    @scores = W3mmdEloScore.where(name: @name).order(:category)

    subquery = W3mmdPlayer.select(:gameid).where(name: @name)
    if @allies.any?
      @allies.each do |ally|
        subquery = subquery
          .joins(%Q[
            INNER JOIN w3mmdplayers AS `#{ally}-ally`
            ON `#{ally}-ally`.`gameid` = `w3mmdplayers`.`gameid`
            AND `#{ally}-ally`.`flag` = `w3mmdplayers`.`flag`
          ])
          .where("`#{ally}-ally`.`name` = ?", ally)
      end
    end
    if @enemies.any?
      @enemies.each do |enemy|
        subquery = subquery
          .joins(%Q[
            INNER JOIN w3mmdplayers AS `#{enemy}-enemy`
            ON `#{enemy}-enemy`.`gameid` = `w3mmdplayers`.`gameid`
            AND `#{enemy}-enemy`.`flag` != `w3mmdplayers`.`flag`
          ])
          .where("`#{enemy}-enemy`.`name` = ?", enemy)
      end
    end

    @games = Game
      .includes(:w3mmd_players)
      .preload(:w3mmd_vars)
      .where('datetime >= ?', @start_range)
      .where('datetime <= ?', @end_range)
      .where(id: subquery)
      .order(id: :desc)
      .page(params[:page])
    @games = @games.where(w3mmdplayers: { category: @category }) if @category.present?

    activity = Game
      .joins(:w3mmd_players)
      .where(id: subquery)
      .where(w3mmdplayers: { name: @name })
      .where('datetime >= ?', @start_range)
      .where('datetime <= ?', @end_range)
    if @category.present?
      activity = activity.where(w3mmdplayers: { category: @category })
    end
    activity = activity.group_by_day(:datetime)
    @activity = (@start_range..@end_range)
    .each_with_object({}) do |date, hash|
      db_date = date.to_s(:db) + ' 00:00:00 UTC'
      hash[date] = activity.fetch(db_date, 0)
    end

    class_data = W3mmdVar
      .select('value_string', 'flag', 'COUNT(*) AS count')
      .joins(:game)
      .joins('INNER JOIN `w3mmdplayers` AS `wp` ON `w3mmdvars`.`gameid` = `wp`.`gameid` AND `w3mmdvars`.`pid` = `wp`.`pid`')
      .where(varname: 'class')
      .where('datetime > ?', @start_range)
      .where('datetime <= ?', @end_range)
      .where(gameid: subquery)
      .where.not(value_string: '""')
      .where.not('flag = ?', '')
      .where('name = ?', @name)
      .group('name, value_string, flag')
    class_data = class_data.where('category = ?', @category) if @category.present?

    class_record = class_data.reduce({}) do |memo, obj|
      memo.deep_merge({ obj.as_troll_class => { obj.flag => obj.count } })
    end

    @classes = class_record.reduce({}) do |memo, (key, val)|
      memo.merge({ key => val['winner'].to_f + val['loser'].to_f })
    end

    @class_win_rates = class_record.reduce({}) do |memo, (key, val)|
      memo.merge({ key => val['winner'].to_f * 100 / @classes[key] })
    end

    @win_rate = class_data
    .reduce({ 'winner' => 0, 'loser' => 0, 'drawer' => 0 }) do |memo, obj|
      memo.merge({ obj.flag =>  memo[obj.flag] + obj.count })
    end
  end

  def index
    @name = params[:name]
    return redirect_to player_path(@name) if @name
	  @placeholder = W3mmdPlayer.select(:name).order('RAND()').pluck(:name).first
  end
end
