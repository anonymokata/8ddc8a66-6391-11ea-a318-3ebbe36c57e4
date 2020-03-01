class POSSystem

  attr_accessor :items, :current_total, :current_items, :specials

  def initialize
    @items = {}
    @specials = {}
    @current_total = 0
    @current_items = Hash.new 0
  end

  def sold_by_weight?(item_name)
    items[item_name.to_sym][:sold_by_weight]
  end

  def item_cost(item_name)
    item = items[item_name.to_sym]
    return item[:price] - item[:markdown] unless item[:markdown].nil?

    item[:price]
  end

  def cost(item_name, amount)
    return calculate_special_cost(item_name, amount) if specials.has_key? item_name

    item_cost(item_name) * amount
  end

  def set_cost(item_name, price, sold_by_weight = false)
    items[item_name.to_sym] = { price: price, sold_by_weight: sold_by_weight }
  end

  def scan_item(item_name, weight = 0)
    current_items[item_name.to_sym] += (weight.zero? ? 1 : weight)
    calculate_current_total
  end

  def remove_item(item_name, weight = 0)
    current_items[item_name.to_sym] -= (weight.zero? ? 1 : weight)
    current_items.delete(item_name.to_sym) if current_items[item_name.to_sym].zero?
    calculate_current_total
  end

  def markdown_item(item_name, markdown)
    items[item_name.to_sym][:markdown] = markdown
  end

  def set_special(item_name, special_type, parameters)
    @specials[item_name.to_sym] = { special_type => parameters }
  end

  def calculate_special_cost(item_name, amount)
    qualifying_specials = amount / specials[item_name][:n_for_x][:n]
    remaining_items = amount % specials[item_name][:n_for_x][:n]

    qualifying_specials * specials[item_name][:n_for_x][:x] + remaining_items * item_cost(item_name)
  end

  def calculate_current_total
    @current_total = 0
    current_items.each do |name, amount|
      @current_total += cost name, amount
    end
  end
end
