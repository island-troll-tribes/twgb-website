require 'is_numeric'

module ParseTrollClass
  def parse_troll_class(str)
    str[1...-1]
      .split('_')
      .drop(1)
      .select { |x| !x.is_numeric? }
      .map(&:titleize)
      .join(' ')
  end
end
