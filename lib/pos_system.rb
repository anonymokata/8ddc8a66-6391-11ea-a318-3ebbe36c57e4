class POSSystem

  attr_reader :items, :current_total

  def initialize
    @items = {}
    @current_total = 0
  end

  def sold_by_weight?(item_name)
    @items[item_name.to_sym][:sold_by_weight]
  end

  def item_cost(item_name)
    item = @items[item_name.to_sym]
    return item[:price] - item[:markdown] unless item[:markdown].nil?

    item[:price]
  end

  def cost(item_name, weight = 0)
    return item_cost(item_name) * weight if sold_by_weight? item_name

    item_cost item_name
  end

  def set_cost(item_name, price, sold_by_weight = false)
    @items[item_name.to_sym] = { price: price, sold_by_weight: sold_by_weight }
  end

  def scan_item(item_name, weight = 0)
    @current_total += cost item_name, weight
  end

  def remove_item(item_name, weight = 0)
    @current_total -= cost item_name, weight
  end

  def markdown_item(item_name, markdown)
    @items[item_name.to_sym][:markdown] = markdown
  end
end
