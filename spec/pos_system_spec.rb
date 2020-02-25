require_relative '../lib/pos_system'

describe POSSystem do
  it 'should return the cost of an item' do
    system = POSSystem.new
    expect(system.cost('soup')). to eq 0.2
  end
end
