class POSSystem

  attr_reader :items, :current_total

  def initialize
    @items = {}
    @current_total = 0
  end

  def sold_by_weight?(item_name)
    @items[item_name.to_sym][:sold_by_weight]
  end

  def cost(item_name, weight = 0)
    return @items[item_name.to_sym][:price] * weight if sold_by_weight? item_name

    @items[item_name.to_sym][:price]
  end

  def set_cost(item_name, price, sold_by_weight = false)
    @items[item_name.to_sym] = { price: price, sold_by_weight: sold_by_weight }
  end

  def scan_item(item_name, weight = 0)
    @current_total += cost item_name, weight
  end
end
