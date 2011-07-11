class Game
  
  LOCATIONS = ["Las Vegas", "New York", "Miami", "Amsterdam", "Frankfurt", "El-Jazier"]
  
  # def self.agent?
  #   rand(100) > 50
  # end
  
  
  # 0 - 300 you're safe, no agents
  # 301 - 600 1 agent has spotted you, but you can run
  # 601 - 900 2 agents have spotted you, but you can fight, or run
  # 901 - 1200 you're being chased, can't run, can fight but will probably lose
  # 1201 - 1500 you're caught, no chance to win. 
  # def self.random_agent
  #     chance = (rand(100) * 30) / 2 #mix it up a bit to make it more random
  #     case chance
  #     when (0..300)
  #       puts "There are no agents following you, but watch your back."
  #     when (301..600)
  #       puts "An agent has spotted you, but you ran away."
  #     when (601..900)
  #       puts "Two agents are hot on your trail."
  #       puts "You run from one, but you had to unleash your glok on the other one."
  #     when (901..1200)
  #       puts "The agent that has been following you wants to make a deal."
  #       puts "You lose $500.00"
  #     when (1201..1500)
  #       puts "You have been caught, there is no way out."
  #       puts "Sorry, game over."
  #       game_over
  #     end
  #   end
  
  def initialize(defaults = {})
    defaults.each_pair { |key,value| instance_variable_set("@#{key}", value) }
  end
  
  def start!
    puts "starting game"
    puts "Player: #{@player.name}"
    

    # if answer.downcase.eql?('s')
    #   puts "Welcome new drug dealer, what is your name?"
    #   name = gets.chomp
    #   @player = Player.new(name)
    #   puts "Nice to meet you #{@player.name}. Here is $500.00 and some weed to get you started."
    #   sleep 2
    #   @player.add_to_drugs({"weed" => 5})
    #   @player.funds += 500
    #   puts "Now that you have that, there is one more thing you will need."
    #   sleep 2
    #   puts "Here is a special plane ticket, and boarding pass."
    #   sleep 2
    #   puts "This will allow you to travel to one of 6 special cities."
    #   sleep 2
    #   puts "You may also need this bag to carry stuff in. You have 30 days."
    #   sleep 3
    #   while @player.days_remaining > 0
    #     puts "What would you like to do?"
    #     puts "1. Buy drugs\n2. Sell drugs\n3. Fly to a new city\n4. Go to the bank.\n5. Check stats."
    #     puts "Select your option:"
    #     option = gets.chomp
    #     case option
    #     when 1.to_s
    #       @player.buy_drugs
    #     when 2.to_s
    #       @player.sell_drugs
    #     when 3.to_s
    #       @player.fly_to_city
    #     when 4.to_s
    #       @player.go_to_bank
    #     when 5.to_s
    #       @player.check_stats
    #     else
    #       puts "You must select a number 1 through 4"
    #     end
    #     
    #     @player.days_remaining -= 1
    #     @player.bank_account.add_daily_interest
    #     if Game.agent?
    #       Game.random_agent
    #     end
    #   end
    #   
    #   puts "You've done it. You're now gangsta!"
    # end

  end
  
  def end!
    echo("Game Over", :red, 0)
    exit
  end
  
end