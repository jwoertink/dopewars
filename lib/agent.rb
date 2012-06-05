class Agent  < Fighter
  
  class << self
    
    def near_by?
      rand(100) % 6 > 3
    end
    
  end
  
end