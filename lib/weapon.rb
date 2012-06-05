class Weapon
  TYPES = {"Fist" => 1, "Brass Knuckle" => 2, "Knife" => 3, "Gun" => 4}
  
  attr_accessor :type, :damage
  
  # Fist deals 1 damage
  # Brass Knuckle deals 2 damage
  # Knife deals 3 damage
  # Gun deals 4 damage
  
  def initialize(options = {})
    @type = options[:type] || "Fist"
    @damage = TYPES[@type]
  end
  
end