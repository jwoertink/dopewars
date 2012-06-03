class Agent
  
  attr_accessor :speed, :accuracy, :evasion, :endurance, :level
  
  class << self
    
    def near_by?
      rand(100) % 6 > 3
    end
    
  end
  
  # The higher the speed, the better chance the agent has of catching you if you try to run
  # The higher the accuracy, the better chance the agent has of shooting you if you try to fight
  def initialize
    @level = 1
    @speed = ((rand(100) / 2) + Math::PI).ceil
    @endurance = ((rand(100) / 2) + Math::PI).ceil
    @evasion = ((rand(100) / 2) + Math::PI).ceil
    @accuracy = ((rand(100) / 2) + Math::PI).ceil
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
  
end