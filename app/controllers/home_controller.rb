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
  	subquery = W3mmdEloScore.select(:category, 'MAX(score) as score').group(:category)
  	@leaders = W3mmdEloScore
	 .joins("INNER JOIN (#{subquery.to_sql}) AS g ON g.category = w3mmd_elo_scores.category AND g.score = w3mmd_elo_scores.score")
	 .where(category: ['2017_league', '2017_1v1_league', 'practice'])
	 .order(category: :asc)

	@quote = @@quotes.sample
	@placeholder = W3mmdPlayer.select(:name).order('RAND()').pluck(:name).first
  end

  def changelog
    @changelog = @@changelog.html_safe
  end

  def competitions
  end
end
