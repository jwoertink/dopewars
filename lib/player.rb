class Player
  include Utilities
  
  attr_accessor :name, :drugs, :wallet, :days_remaining, :bank_account, :end_of_turn, :speed, :accuracy, :evasion, :endurance
  
  def initialize(defaults = {})
    @name = defaults[:name]
    @drugs = defaults[:drugs]
    @wallet = defaults[:wallet]
    @speed = ((rand(100) / 2) + Math::PI).ceil
    @accuracy = ((rand(100) / 2) + Math::PI).ceil
    @evasion = ((rand(100) / 2) + Math::PI).ceil
    @endurance = ((rand(100) / 2) + Math::PI).ceil
    @bank_account = Bank.new
    @end_of_turn = false
    @free = true
  end
  
  def running
    @speed + @endurance
  end
  
  def defending
    @evasion
  end
  
  def attacking
    @accuracy
  end
  
  def stats
    str = ""
    str << "Stats for #{name}\n"
    str << "Drugs:\n"
    drugs.each { |k,v| str << "- #{k} x #{v}\n" }
    str << "Wallet: $#{wallet}\n"
    str << "Total savings: $#{bank_account.savings_account}\n"
    str << "Total loans: $#{bank_account.loan_amount}\n"
    str
  end
  
  # you can buy the drug if you have enough money for the qty of that drug
  def can_buy_drug?(price, qty)
    wallet > (price * qty) 
  end
  
  # you can sell the drug if there is a market for it on the streets
  def can_sell_drug?(drug)
    drug.can_be_sold?
  end
  
  def add_to_drugs(drugs)
    drugs.each_pair do |drug, amount|
      if @drugs.has_key?(drug)
        @drugs[drug] += drugs[drug]
      else
        @drugs.update({drug => amount})
      end
    end
  end
  
  def remove_from_drugs(drugs)
    drugs.each_pair do |drug, amount|
      @drugs[drug] -= drugs[drug]
    end    
  end
  
  def captured?
    !@free
  end
  
  def fight(agent)
    # 0 = agent shoots first, 1 = you shoot first
    if rand(10) % 2 == 0
      result = defending > agent.attacking
    else
      result = attacking > agent.defending
      # need to add bonus for killing an agent
    end
    @free = result
  end
  
  def run(agent)
    if running > agent.running
      # You run faster than the agent
      result = true
    else
      result = false
    end
    @free = result
  end
  
  def start_turn!
    @end_of_turn = false
  end
  
  def end_turn!
    bank_account.add_daily_interest
    battle_agent if agent_encounter?
    @end_of_turn = true
  end
  
  def end_of_turn?
    @end_of_turn
  end
  
  def agent_encounter?
    Agent.near_by?
  end
  
  # This belongs in the game
  def battle_agent
    agent = Agent.new
    echo("#{name}, there is an agent chasing you!", :green)
    choice = ask("Will you [F]ight or [R]un?")
    case choice.downcase
    when 'f'
      result = fight(agent)
    when 'r'
      result = run(agent)
    else
      echo("You must select F or R", :red)
      battle_agent
    end
    if result
      echo("You escaped this time, but be on the look out", :green)
    else
      echo("You have been captured.", :red)
    end
  end
  
end
