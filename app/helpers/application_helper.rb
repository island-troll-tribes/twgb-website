module ApplicationHelper
  def active_nav(name, path)
    classes = 'active' if current_page? path
    content_tag :li, class: classes do
      link_to name, path
    end
  end

  def category_selector(current, opts={})
    opts = { name: 'category', class: 'form-control input-sm' }.merge(opts)
    categories = [''] + W3mmdEloScore.categories
    options = categories.collect do |category|
      content_tag :option, category, value: category, selected: category == current
    end.join('')
    select_tag opts[:name], options.html_safe, opts
  end

  def wc3_link(text='Warcraft III', opts={ target: '_BLANK' })
    link_to text, 'http://us.blizzard.com/en-us/games/war3/', opts
  end

  def discord_link(text='Discord', opts={ target: '_BLANK' })
    link_to text, 'https://discord.gg/Rh9JdKs', opts
  end

  def forums_link(text='Forums', opts={ target: '_BLANK' })
    link_to text, 'http://islandtrolltribes.foroomy.com/index.php', opts
  end

  def suggestions_link(text='Suggestions', opts={ target: '_BLANK' })
    link_to text, 'https://trello.com/b/jxK9cOHx/island-troll-tribes', opts
  end

  def wiki_link(text='Wiki', opts={ target: '_BLANK' })
    link_to text, 'http://islandtrolltribes.wikia.com/wiki/Island_Troll_Tribes_Official_Wiki', opts
  end

  def github_link(text='GitHub', opts={ target: '_BLANK' })
    link_to text, 'https://github.com/island-troll-tribes/island-troll-tribes', opts
  end
end
