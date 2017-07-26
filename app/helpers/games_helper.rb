module GamesHelper
  include ParseTrollClass

  def player_troll_icon(player)
    return question_icon unless player.troll_class.present?
    troll_icon player.troll_class, title: player.name
  end

  def troll_icon(troll_class, opts={ title: troll_class } )
    icon = troll_class.gsub(' ', '').downcase
    image_tag "icons/#{icon}.png", opts
  end

  def question_icon
    image_tag "icons/question.png"
  end
end
