class Agent
  
  class << self
    
    def available?
      rand(100) % 6 > 3
    end
    
  end
  
  def initialize
    
  end
  
end