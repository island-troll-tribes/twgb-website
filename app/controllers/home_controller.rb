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
    get_statistics
  end

  private

  def get_leaders
    subquery = W3mmdEloScore.select(:category, 'MAX(score) as score').group(:category)
    @leaders = W3mmdEloScore
      .joins("INNER JOIN (#{subquery.to_sql}) AS g ON g.category = w3mmd_elo_scores.category AND g.score = w3mmd_elo_scores.score")
      .where(category: ['2017_league', '2017_1v1_league', 'practice'])
      .order(category: :asc)
  end

  def get_statistics
    @category = params[:category]
    @start_range = params[:start_range] ? Date.strptime(params[:start_range], '%m/%d/%Y') : Date.new(2016, 10, 1)
    @end_range = params[:end_range] ? Date.strptime(params[:end_range], '%m/%d/%Y') : Date.tomorrow

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
end
