class HomeController < ApplicationController
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  contents = File.read(Rails.root.join('app', 'assets', 'changelog.md'))
  @@changelog = markdown.render(contents)

  def index
    @w3mmd_elo_scores = W3mmdEloScore.order(score: :desc).all
  end

  def changelog
    @changelog = @@changelog.html_safe
  end
end
