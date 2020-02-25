class POSSystem

  attr_accessor :prices

  def initialize
    @prices = {
        soup: 1.89,
        crackers: 1.99
    }
  end

  def cost(item)
    @prices[item]
  end

  def set_cost(item, price)
    @prices[item] = price
  end
end
