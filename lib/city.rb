class City
  include Utilities
  attr_accessor :name, :drugs, :transactions, :gym_closed
  
  LOCATIONS = ["Las Vegas", "New York", "Miami", "Amsterdam", "Frankfurt", "El-Jazier"]
  
  def initialize(options = {})
    @name = options[:name] ||= LOCATIONS.sort_by { rand }.first
    gather_drugs
    @transactions = 0
    @gym_closed = false
  end
  
  def gather_drugs
    @drugs = []
    @drugs += Drug::TYPES.collect { |d| Drug.new({name: d, price: market_price_for_drug, quantity: 0}) }
  end
  
  def gym_closed?
    @gym_closed
  end
  
  # currently returns a random number
  def market_price_for_drug
    rand(500) + 10
  end
  
  
end