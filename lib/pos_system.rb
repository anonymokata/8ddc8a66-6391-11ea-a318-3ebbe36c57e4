class POSSystem

  attr_accessor :items

  def initialize
    @items = {
        soup:     { price: 1.89 },
        crackers: { price: 1.99 }
    }
  end

  def cost(item_name)
    @items[item_name.to_sym][:price]
  end

  def set_cost(item_name, price)
    @items[item_name.to_sym] = { price: price }
  end
end
