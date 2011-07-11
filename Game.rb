class Game
  
  LOCATIONS = ["Las Vegas", "New York", "Miami", "Amsterdam", "Frankfurt", "El-Jazier"]
  
  def self.days
    30
  end
  
  def self.agent?
    rand(100) > 50
  end
  
  
  # 0 - 300 you're safe, no agents
  # 301 - 600 1 agent has spotted you, but you can run
  # 601 - 900 2 agents have spotted you, but you can fight, or run
  # 901 - 1200 you're being chased, can't run, can fight but will probably lose
  # 1201 - 1500 you're caught, no chance to win. 
  def self.random_agent
    chance = (rand(100) * 30) / 2 #mix it up a bit to make it more random
    case chance
    when (0..300)
      puts "There are no agents following you, but watch your back."
    when (301..600)
      puts "An agent has spotted you, but you ran away."
    when (601..900)
      puts "Two agents are hot on your trail."
      puts "You run from one, but you had to unleash your glok on the other one."
    when (901..1200)
      puts "The agent that has been following you wants to make a deal."
      puts "You lose $500.00"
    when (1201..1500)
      puts "You have been caught, there is no way out."
      puts "Sorry, game over."
      game_over
    end
  end
  
  def self.game_over
    exit
  end
  
  def start!
    puts "starting game"
  end
  
end