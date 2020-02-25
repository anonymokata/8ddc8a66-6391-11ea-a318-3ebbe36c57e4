require_relative '../lib/item'

describe Item do
  it 'should have a name and a price' do
    item = Item.new 'soup', 1.89
    expect(item.name). to eq 'soup'
    expect(item.price). to eq 1.89
  end

  it 'can be set to sell by weight' do
    item = Item.new 'ground beef', 5.99, true
    expect(item.sell_by_weight). to be true
  end
end
