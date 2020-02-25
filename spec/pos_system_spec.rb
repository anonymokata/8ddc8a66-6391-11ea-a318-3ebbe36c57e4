require_relative '../lib/pos_system'

describe POSSystem do

  before(:each) do
    @system = POSSystem.new
  end

  it 'should return the cost of an item' do
    @system.set_cost'soup', 1.89
    @system.set_cost'crackers', 1.99
    expect(@system.cost('soup')). to eq 1.89
    expect(@system.cost('crackers')). to eq 1.99
  end

  it 'should return the cost of an item sold by weight' do
    cost_per_lb = 5.99
    @system.set_cost 'beef', cost_per_lb, true
    expect(@system.cost('beef', 1)). to eq cost_per_lb * 1
    expect(@system.cost('beef', 2)). to eq cost_per_lb * 2
    expect(@system.cost('beef', 0.5)). to eq cost_per_lb * 0.5
    expect(@system.cost('beef', 1.5)). to eq cost_per_lb * 1.5
  end

  it 'should allow you to set the cost of an item' do
    @system.set_cost'soup', 1.00
    expect(@system.cost('soup')). to eq 1.00
  end

  it 'should allow you to set if an item is sold by weight' do
    @system.set_cost'beef', 5.99, true
    expect(@system.sold_by_weight?('beef')). to be true
  end

  it 'should start with a current total of 0' do
    expect(@system.current_total). to eq 0
  end

  it 'should increase current total when an item is scanned in' do
    @system.set_cost'soup', 1.89
    @system.scan_item('soup')
    expect(@system.current_total). to eq 1.89
  end
end
