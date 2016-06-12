class Container

  attr_accessor :size, :quantity, :cost, :name, :item_count, :items

  # Returns an array of hashes
  def self.all
    YAML.load(File.open(File.join(Utilities::GAME_ROOT, "config", "containers.yml")))
  end

  def self.find(key)
    all.find { |c| c["size"].eql?(key) }
  end

  def initialize(options = {})
    attributes = if options[:size]
      Container.find(options[:size])
    else
      Container.all.first
    end
    attributes.each do |k, v|
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
