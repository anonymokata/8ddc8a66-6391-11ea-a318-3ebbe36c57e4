require_relative '../lib/item'

describe Item do
  it 'should have a name and a price' do
    item = Item.new :soup, 1.89
    expect(item.name). to eq :soup
    expect(item.price). to eq 1.89
  end
end
