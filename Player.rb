require 'game'

class Player
  attr_accessor :name, :drugs, :funds, :current_location, :days_remaining, :bank_account
  
  def initialize(name)
    @name = name
    @drugs = Hash.new
    @funds = 0
    @current_location = "Las Vegas"
    @days_remaining = Game.days
    @bank_account = Bank.new
  end
  
  # you can buy the drug if you have enough money for the qty of that drug
  def can_buy_drug?(price, qty)
    self.funds > (price * qty) 
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
  
  def buy_drugs
    puts "Select the number of the drug you want to buy."
    Drug::TYPES.each_with_index do |drug, select_number|
      @price = Drug.display_price
      max_amount = @funds / @price
      puts "#{select_number + 1}. #{drug} @ $#{@price} {#{max_amount}}\n"
    end
    drug_choice = gets.chomp
    drug = Drug::TYPES[drug_choice.to_i - 1]
    puts "How many?"
    drug_amount = gets.chomp
    decrease = (@price * drug_amount.to_i)
    if self.can_buy_drug?(@price, drug_amount.to_i)
      self.add_to_drugs({drug => drug_amount.to_i})
      @funds -= decrease
    else
      puts "You can't buy that many."
    end
  end
  
  def sell_drugs
    puts "Which of your drugs would you like to sell?"
    i = 0
    @drugs.each_pair do |drug, amount|
      @price = Drug.display_price
      puts "#{i + 1}. #{drug} x #{amount} @ $#{@price}.00ea.\n"
      i +=1
    end
    drug_choice = gets.chomp
    drug = @drugs.keys[i - 1]
    puts "How many?"
    drug_amount = gets.chomp
    if drug_amount.to_i <= @drugs[drug]
      self.remove_from_drugs({drug => drug_amount.to_i})
      increase = @price * drug_amount.to_i
      @funds += increase
    else
      puts "You can't sell more then #{@drugs[drug]} of #{drug}."
    end
  end
  
  def fly_to_city
    puts "Select the number of the city you want to fly to."
    Game::LOCATIONS.each_with_index do |city, select_number|
      next if current_location.eql?(city)
      puts "#{select_number + 1}. #{city}\n"
    end
    answer = gets.chomp
    self.current_location = Game::LOCATIONS[answer.to_i - 1]
    @days_remaining -= 1
  end
  
  def go_to_bank
    puts "*****************"
    puts "***** BANK ******"
    puts "*****************"
    puts "Welcome to the swiss bank exchange."
    puts "Choose an option."
    puts "1. Take out a loan."
    puts "2. Put money in savings."
    puts "3. Leave."
    answer = gets.chomp
    loop do
      case answer
      when "1"
        puts "How much?"
        amount = gets.chomp
        @funds += amount.to_i
        @bank_account.increase_loan(amount.to_i)
        break
      when "2"
        puts "How much?"
        amount = gets.chomp
        if amount.to_i > @funds
          puts "Sorry, you don't have that much money."
        else
          @funds -= amount.to_i
          @bank_account.increase_savings(amount.to_i)
          break
        end
      when "3"
        puts "Goodbye."
        break
      else
        puts "You have to select option 1, 2 or 3"
        answer = gets.chomp
      end
    end
  end
  
  def check_stats
    puts "**********************"
    puts "******* STATS ********"
    puts "**********************"
    puts "Stats for #{@name}"
    puts "Drugs:"
    @drugs.each { |k,v| puts "-#{k} x #{v}" }
    puts "Wallet: $#{@funds}.00"
    puts "Current Location: #{@current_location}"
    puts "Days remaining: #{@days_remaining}"
    puts "Total savings: #{@bank_account.savings_account}"
    puts "Total loans: #{@bank_account.loan_amount}"
  end
  
  def fight
  end
  
  def run
  end
  
end
