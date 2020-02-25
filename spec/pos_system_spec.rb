require_relative '../lib/pos_system'

describe POSSystem do
  it 'should return the cost of an item' do
    system = POSSystem.new
    expect(system.cost('soup')). to eq 1.89
    expect(system.cost('crackers')). to eq 1.99
  end

  it 'should allow you to set the cost of an item' do
    system = POSSystem.new
    system.set_cost('soup', 1.00)
    expect(system.cost('soup')). to eq 1.00
  end

  it 'should allow you to set if an item is sold by weight' do
    system = POSSystem.new
    system.set_cost('beef', 5.99, true)
    expect(system.items[:beef][:sold_by_weight]). to be true
  end
end
