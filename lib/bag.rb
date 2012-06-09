require 'yaml'

class Bag
  
  attr_accessor :size, :quantity, :cost, :item_count
  
  # Returns an array of hashes
  def self.all
    YAML::load(File.open(File.expand_path(File.join(File.dirname(__FILE__), '..', "bags.yml"))))
  end
  
  def self.find(key)
    all.collect { |b| b if b["size"].eql?(key) }.compact.first
  end
  
  def initialize(options = {})
    if options[:size]
      bag = Bag.find(options[:size])
    else
      bag = Bag.all.first
    end
    bag.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
    @item_count = 0
  end
  
  def add(item_quantity)
    @item_count += item_quantity
  end
  
  def remove(item_quantity)
    @item_count -= item_quantity
  end
  
  def full?
    @item_count >= @quantity
  end
  
end