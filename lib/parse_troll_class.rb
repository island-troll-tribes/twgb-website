module ParseTrollClass
  def parse_troll_class(str)
    str[1...-1].split('_').drop(1).map(&:titleize).join(' ')
  end
end
