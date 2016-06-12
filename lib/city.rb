class City
  include Utilities
  attr_accessor :name, :drugs, :transactions, :gym_closed

  LOCATIONS = ["Las Vegas", "New York", "Miami", "Amsterdam", "Frankfurt", "El-Jazier"]

  def initialize(options = {})
    @name = options.fetch(:name, LOCATIONS.sample)
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

  # TODO: If the particular drug has been flooded in this city's market, return a lower price when buying. Return higher price when the specific drug is in high demand. Or 0 for drugs not available to buy/sell in this market.
  def market_price_for_drug
    rand(500) + 10
  end

end
