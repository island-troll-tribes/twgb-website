class HomeController < ApplicationController
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  contents = File.read(Rails.root.join('app', 'assets', 'changelog.md'))
  @@changelog = markdown.render(contents)

  def index
    category = '2017_1v1_league'
    @w3mmd_elo_scores = W3mmdEloScore.where(category: category).order(score: :desc).all
  end

  def changelog
    @changelog = @@changelog.html_safe
  end
end
