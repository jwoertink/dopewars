require 'game'

class Drug
  
  TYPES = ["weed", "ecstacy", "shrooms", "oxycotin", "acid", "ruffy", "crack", "cocaine", "heroin", "crystal meth"]
  
  def can_be_sold?
    true
  end
  
  
  def self.display_price
    rand(500) + 10
  end
  
end