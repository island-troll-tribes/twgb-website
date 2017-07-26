class HomeController < ApplicationController
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  contents = File.read(Rails.root.join('app', 'assets', 'changelog.md'))
  @@changelog = markdown.render(contents)

  @@quotes = [
    "En fuego bebe!",
    "The ends justify da means!",
    "I be down wid dat.",
    "Fire it up, mon!",
    "What you want be burned?",
    "Someone call for de docter?",
    "I hear de summons!",
    "What you be cravin'?",
    "Taz'dingo!",
    "Dat be good choice, mon!",
    "Who you want me kill?",
    "What'you want me do?",
    "Where'you want me go?",
    "It's time for a little blood!",
  ]

  def index
    @quote = @@quotes.sample
    @placeholder = W3mmdPlayer.select(:name).order('RAND()').pluck(:name).first

    get_leaders
  end

  def changelog
    @changelog = @@changelog.html_safe
  end

  def competitions
  end

  def meta
    get_category_and_date_range
    get_class_win_rates
    get_activity
    get_player_activity
  end

  def player_last_played
    get_category_and_date_range
    @min_games = params[:min_games]
    min_games = if @min_games.present? then @min_games.to_i else 1 end
    @max_games = params[:max_games]
    max_games = if @max_games.present? then @max_games.to_i else 9e9 end
    @twgb_only = params[:twgb_only].present?
    @players = GamePlayer
      .joins(:game)
      .select(
        :name,
        'COUNT(*) AS num_games',
        'MAX(datetime) AS last_played'
      )
      .where('datetime >= ?', @start_range)
      .where('datetime <= ?', @end_range)
      .group(:name)
      .having('num_games >= ?', min_games)
      .having('num_games <= ?', max_games)
      .order('last_played DESC')
    @players = @players.where(reserved: 1) if @twgb_only
  end

  private

  def get_leaders
    subquery = W3mmdEloScore.select(:category, 'MAX(score) as score').group(:category)
    @leaders = W3mmdEloScore
      .joins("INNER JOIN (#{subquery.to_sql}) AS g ON g.category = w3mmd_elo_scores.category AND g.score = w3mmd_elo_scores.score")
      .where(category: ['2017_league', '2017_1v1_league', 'practice'])
      .order(category: :asc)
  end

  def get_activity
    activity = Game
      .where('datetime >= ?', @start_range)
      .where('datetime <= ?', @end_range)
    activity = activity.where('EXISTS (SELECT 1 FROM w3mmdplayers WHERE games.id = gameid AND category = ?)', @category) if @category.present?
    activity = activity.group_by_day(:datetime)
    @activity = (@start_range..@end_range)
    .each_with_object({}) do |date, hash|
      db_date = date.to_s(:db) + ' 00:00:00 UTC'
      hash[date] = activity.fetch(db_date, 0)
    end
  end

  def get_class_win_rates
    class_data = W3mmdVar
      .select('value_string', 'flag', 'COUNT(*) AS count')
      .joins(:game)
      .joins('INNER JOIN `w3mmdplayers` AS `wp` ON `w3mmdvars`.`gameid` = `wp`.`gameid` AND `w3mmdvars`.`pid` = `wp`.`pid`')
      .where(varname: 'class')
      .where('datetime >= ?', @start_range)
      .where('datetime <= ?', @end_range)
      .where.not(value_string: '""')
      .where.not('flag = ?', '')
      .group('value_string, flag')
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
  end

  def get_player_activity
    players = W3mmdPlayer
      .joins(:game)
      .select(
        'COUNT(DISTINCT name) AS count',
        'DATE_FORMAT(datetime, "%Y-%m-01 00:00:00 EST") AS date_slice',
      )
      .where('datetime >= ?', @start_range)
      .where('datetime <= ?', @end_range)
      .group('date_slice')
      .order('date_slice')
    players = players.where(category: @category) if @category.present?

    @players = players.each_with_object({}) do |month, memo|
      memo[month[:date_slice]] = month[:count]
    end
  end
end
