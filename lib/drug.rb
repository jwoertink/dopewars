class Drug
  attr_accessor :name, :price, :quantity
  
  TYPES = ["weed", "ecstacy", "shrooms", "oxycotin", "acid", "ruffies", "crack", "cocaine", "heroin", "crystal meth"]
  
  def self.street_price
    rand(500) + 10
  end
  
  def initialize(defaults = {})
    defaults.each_pair { |key,value| instance_variable_set("@#{key}", value) }
  end
  
  def can_be_sold?
    true
  end
  
end