class String
  def is_numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end
end  
