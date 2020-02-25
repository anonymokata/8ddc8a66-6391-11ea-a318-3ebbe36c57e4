class Item

  attr_reader :name, :price, :sell_by_weight

  def initialize(name, price, sell_by_weight = false)
    @name = name
    @price = price
    @sell_by_weight = sell_by_weight
  end
end
