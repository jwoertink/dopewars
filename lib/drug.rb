class Drug
  attr_accessor :name, :price, :quantity
  
  TYPES = ["weed", "ecstacy", "shrooms", "oxycotin", "acid", "roofies", "crack", "cocaine", "heroin", "meth"]
  
  def initialize(defaults = {})
    defaults.each_pair { |key,value| instance_variable_set("@#{key}", value) }
    @sellable = true
  end
  
  def can_be_sold?
    @sellable
  end

  
end