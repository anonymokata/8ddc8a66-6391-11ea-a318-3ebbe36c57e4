require_relative '../lib/pos_system'

describe POSSystem do
  it 'should return the cost of an item' do
    system = POSSystem.new
    expect(system.cost(:soup)). to eq 1.89
    expect(system.cost(:crackers)). to eq 1.99
  end
end
