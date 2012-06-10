class Player < Fighter
  
  attr_accessor :name, :drugs, :wallet, :bag, :days_remaining, :bank_account, :end_of_turn, :transactions
  
  def initialize(defaults = {})
    @name = defaults[:name].capitalize
    @drugs = defaults[:drugs]
    @wallet = defaults[:wallet]
    @level = 1
    @hp = 2
    @speed = ((rand(100) / 2) + Math::PI).ceil
    @accuracy = ((rand(100) / 2) + Math::PI).ceil
    @evasion = ((rand(100) / 2) + Math::PI).ceil
    @endurance = ((rand(100) / 2) + Math::PI).ceil
    @bank_account = Bank.new
    @weapon = Weapon.new
    @bag = Bag.new
    @end_of_turn = false
    @free = true
  end
  
  def running(boost)
    @speed + @endurance + boost.to_i
  end
  
  def defending
    @evasion
  end
  
  def attacking(boost)
    @accuracy + boost.to_i
  end
  
  def workout!
    effort = rand(100)
    level_up! if effort > 50
  end
  
  def level_up!
    @level += 1
    @hp = max_hit_points
    @speed += @level
    @accuracy += @level
    @evasion += @level
    @endurance += @level
  end
  
  def stats(full = true)
    if full
      full_stats
    else
      mini_stats
    end
  end
  
  def final_stats
    # Add savings + wallet
    # Pay back loan
    # Display level, total cash, # of total drugs
  end
  
  def visited_gym?(city)
    city.gym_closed?
  end
  
  # you can buy the drug if you have enough money for the qty of that drug
  def can_buy_drug?(price, qty)
    wallet > (price * qty) 
  end
  
  # you can sell the drug if there is a market for it on the streets
  def can_sell_drug?(drug)
    drug.can_be_sold?
  end
  
  def has_drugs?
    !@drugs.empty?
  end
  
  # See if the player has enough money to buy drugs from a particular city
  def can_afford_drugs?(drugs_from_city)
    num_of_purchasable_drugs = 0
    drugs_from_city.each do |drug|
      num_of_purchasable_drugs += 1 unless (@wallet / drug.price).zero?
    end
    num_of_purchasable_drugs > 0
  end
  
  def add_to_drugs(drugs_to_add)
    drugs_to_add.each_pair do |drug, amount|
      drug = drug.to_sym
      if @drugs.has_key?(drug)
        @drugs[drug] += amount
      else
        @drugs.update({drug => amount})
      end
    end
  end
  
  def remove_from_drugs(drugs_to_remove)
    drugs_to_remove.each_pair do |drug, amount|
      @drugs[drug] -= drugs_to_remove[drug]
      @drugs.delete(drug) if @drugs[drug].zero?
    end    
  end
  
  def captured?
    not free? or dead?
  end
  
  def free?
    @free
  end
  
  def fight(agent, with_boost = nil)
    21 > 32
    hit_opponent = rand(attacking(with_boost)) >= rand(agent.defending)
    if hit_opponent
      agent.hp -= weapon.damage
      hit_amount = weapon.damage
    else
      hit_amount = 0
    end
    hit_amount
  end
  
  def run_from(agent, with_boost = nil)
    if running(with_boost) > agent.running
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
    @end_of_turn = true
  end
  
  def end_of_turn?
    @end_of_turn
  end
  
  def encounter_agent?
    Agent.near_by?
  end
  
  private
  
    def full_stats
      str = ""
      str << "Stats #{name}:\n"
      str << " Drugs:\n"
      drugs.each { |k,v| str << " - #{k} x #{v}\n" }
      str << " Wallet: $#{wallet}\n"
      str << " Total savings: $#{bank_account.savings_account}\n"
      str << " Total loans: $#{bank_account.loan_amount}\n"
      str << mini_stats
      str
    end

    def mini_stats
      str = ""
      str << " Level: #{level}\n"
      str << " Hit points: #{hp}\n"
      str << " Speed: #{speed}\n"
      str << " Accuracy: #{accuracy}\n"
      str << " Evasion: #{evasion}\n"
      str << " Endurance: #{endurance}\n"
      str
    end
  
end
