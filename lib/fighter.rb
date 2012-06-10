class Fighter
  
  attr_accessor :speed, :accuracy, :evasion, :endurance, :level, :hp, :weapon
  
  def initialize
    @level = 1
    @speed = ((rand(95) / 2) + Math::PI).floor
    @endurance = ((rand(95) / 2) + Math::PI).floor
    @evasion = ((rand(90) / 2) + Math::PI).floor
    @accuracy = ((rand(90) / 2) + Math::PI).floor
    @hp = 2
    @weapon = Weapon.new
  end
  
  def running
    @speed + @endurance
  end
  
  def attacking
    @accuracy
  end
  
  def defending
    @evasion
  end
  
  def max_hit_points
    @level * 2
  end
  alias :max_hp :max_hit_points
  
  def attack_first?
    rand(10) % 2 == 0
  end
  
  def attacks(opponent, boost = nil)
    if rand(attacking) >= rand(opponent.defending)
      opponent.hp -= weapon.damage
      hit_amount = weapon.damage
    else
      hit_amount = 0
    end
    hit_amount
  end
  
  def fight(opponent, with_boost = nil)
    attacks(opponent, with_boost)
  end
  
  def dead?
    @hp <= 0
  end
  
  def alive?
    not dead?
  end
  
end