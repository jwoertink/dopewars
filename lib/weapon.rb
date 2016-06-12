require 'yaml'

class Weapon

  attr_accessor :type, :damage, :cost, :level

  # Fist deals 1 damage
  # Brass Knuckle deals 2 damage
  # Knife deals 3 damage
  # Gun deals 4 damage

  def self.find(key)
    all.collect { |w| w if w["type"].eql?(key) }.compact.first
  end

  # Returns an array of hashes
  def self.all
    YAML.load(File.open(File.join(GAME_ROOT, "config", "weapons.yml")))
  end

  def initialize(options = {})
    if options[:type]
      weapon = Weapon.find(options[:type])
    else
      weapon = Weapon.all.first
    end
    weapon.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

end
