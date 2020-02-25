class POSSystem

  attr_accessor :prices

  def initialize
    @prices = {
        soup: Item.new('soup', 1.89),
        crackers: Item.new('crackers', 1.99)
    }
  end

  def cost(item_name)
    @prices[item_name.to_sym].price
  end

  def set_cost(item_name, price)
    @prices[item_name.to_sym] = Item.new item_name, price
  end
end
