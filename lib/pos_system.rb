class POSSystem

  attr_reader :items

  def initialize
    @items = {
        soup:     { price: 1.89 },
        crackers: { price: 1.99 }
    }
  end

  def cost(item_name)
    @items[item_name.to_sym][:price]
  end

  def set_cost(item_name, price, sold_by_weight = false)
    @items[item_name.to_sym] = { price: price, sold_by_weight: sold_by_weight }
  end
end
