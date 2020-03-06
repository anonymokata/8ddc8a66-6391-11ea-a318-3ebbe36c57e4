# frozen_string_literal: true

require_relative '../lib/pos_system'

describe POSSystem do
  before(:each) do
    @system = POSSystem.new
    @system.set_cost 'soup', 1.89
    @system.set_cost 'crackers', 1.99
    @system.set_cost 'beef', 5.99, true
  end

  it 'should return the cost of an item' do
    expect(@system.cost('soup', 1)). to eq 1.89
    expect(@system.cost('crackers', 1)). to eq 1.99
  end

  it 'should return the cost of an item sold by weight' do
    expect(@system.cost('beef', 1)). to eq 5.99 * 1
    expect(@system.cost('beef', 2)). to eq 5.99 * 2
    expect(@system.cost('beef', 0.5)). to eq 5.99 * 0.5
    expect(@system.cost('beef', 1.5)). to eq 5.99 * 1.5
  end

  it 'should allow you to set the cost of an item' do
    @system.set_cost 'soup', 1.00
    expect(@system.cost('soup', 1)). to eq 1.00
  end

  it 'should allow you to set if an item is sold by weight' do
    expect(@system.sold_by_weight?('beef')). to be true
  end

  it 'should start with a current total of 0' do
    expect(@system.current_total). to eq 0
  end

  it 'should increase current total when an item is scanned in' do
    @system.scan_item('soup')
    expect(@system.current_total). to eq 1.89
    @system.scan_item('soup')
    expect(@system.current_total). to eq 3.78
  end

  it 'should increase current total when an item is scanned in with a weight' do
    @system.scan_item 'beef', 2
    expect(@system.current_total).to eq 11.98
  end

  it 'should allow you to remove an item, correcting the current total' do
    @system.scan_item 'soup'
    expect(@system.current_total).to eq 1.89
    @system.remove_item 'soup'
    expect(@system.current_total).to eq 0
  end

  it 'should allow you to remove an item with weight, correcting the current total' do
    @system.scan_item 'beef', 1.26
    expect(@system.current_total).to eq 7.55
    @system.remove_item 'beef', 1.26
    expect(@system.current_total).to eq 0
  end

  it 'should allow you to markdown an item' do
    @system.markdown_item 'soup', 0.20
    @system.scan_item 'soup'
    expect(@system.current_total).to eq 1.69
  end

  it 'should keep track of items currently scanned in' do
    @system.scan_item 'soup'
    current_items = { soup: 1 }
    expect(@system.current_items).to eq current_items
    @system.scan_item 'soup'
    current_items = { soup: 2 }
    expect(@system.current_items).to eq current_items
  end

  it 'should keep track of the weight of items currently scanned in' do
    @system.scan_item 'beef', 2
    current_items = { beef: 2 }
    expect(@system.current_items).to eq current_items
    @system.scan_item 'beef', 1.5
    current_items = { beef: 3.5 }
    expect(@system.current_items).to eq current_items
  end

  it 'should keep track of items currently scanned in when one is removed' do
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    current_items = { soup: 2 }
    expect(@system.current_items).to eq current_items
    @system.remove_item 'soup'
    current_items = { soup: 1 }
    expect(@system.current_items).to eq current_items
  end

  it 'should keep track of the weight of items currently scanned in when some is removed' do
    @system.scan_item 'beef', 1
    @system.scan_item 'beef', 2.5
    current_items = { beef: 3.5 }
    expect(@system.current_items).to eq current_items
    @system.remove_item 'beef', 2
    current_items = { beef: 1.5 }
    expect(@system.current_items).to eq current_items
  end

  it 'should allow you to set a special in the form of N for $X' do
    @system.set_special 'soup', :n_for_x, { n: 3, x: 5 }
    special = { n_for_x: { n: 3, x: 5 } }
    expect(@system.specials[:soup]).to eq special
  end

  it 'should allow you to set a special in the form of Buy N items get M at %X off with and without a limit' do
    @system.set_special 'soup', :n_get_m_at_x_off, { n: 2, m: 1, x: 0.50 }
    special = { n_get_m_at_x_off: { n: 2, m: 1, x: 0.50 } }
    expect(@system.specials[:soup]).to eq special

    @system.set_special 'soup', :n_get_m_at_x_off, { n: 2, m: 1, x: 0.50, limit: 6 }
    special = { n_get_m_at_x_off: { n: 2, m: 1, x: 0.50, limit: 6 } }
    expect(@system.specials[:soup]).to eq special
  end

  it 'should support a special in the form of N for $X and calculate total accordingly' do
    @system.set_special 'soup', :n_for_x, { n: 3, x: 5 }
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    expect(@system.current_total).to eq 5.00
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    expect(@system.current_total).to eq 10.00

    @system.set_special 'soup', :n_for_x, { n: 3, x: 5, limit: 3 }
    @system.calculate_current_total
    expect(@system.current_total).to eq 10.67
  end

  it 'should support a special in the form of Buy N items get M at %X off with and without a limit and calculate the total accordingly' do
    @system.set_cost 'soup', 1.00
    @system.set_special 'soup', :n_get_m_at_x_off, { n: 2, m: 1, x: 0.50 }
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    expect(@system.current_total).to eq 2.50
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    expect(@system.current_total).to eq 7.50

    @system.set_special 'soup', :n_get_m_at_x_off, { n: 2, m: 1, x: 0.50, limit: 6 }
    @system.calculate_current_total
    expect(@system.current_total).to eq 8.00
  end

  it 'should support removing an item that invalidates a special and modify the current total' do
    @system.set_special 'soup', :n_for_x, { n: 3, x: 5 }
    @system.set_cost 'soup', 2.00
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    @system.scan_item 'soup'
    expect(@system.current_total).to eq 5
    @system.remove_item 'soup'
    expect(@system.current_total).to eq 4
  end

  it 'should allow you to set a special in the form of Buy N lbs get M lbs for %X off' do
    @system.set_special 'beef', :n_get_m_at_x_off, { n: 2, m: 1, x: 0.50 }
    special = { n_get_m_at_x_off: { n: 2, m: 1, x: 0.50 } }
    expect(@system.specials[:beef]).to eq special
  end

  it 'should support a special in the form of Buy N lbs get M lbs for %X off with and without a limit and calculate the total accordingly' do
    @system.set_cost 'beef', 1.00, true
    @system.set_special 'beef', :n_get_m_at_x_off, { n: 2, m: 1, x: 0.50 }
    @system.scan_item 'beef', 1.26
    expect(@system.current_total).to eq 1.26
    @system.scan_item 'beef', 0.74
    expect(@system.current_total).to eq 2.00
    @system.scan_item 'beef', 4.26
    expect(@system.current_total).to eq 5.26

    @system.set_special 'beef', :n_get_m_at_x_off, { n: 2, m: 1, x: 0.50, limit: 3 }
    @system.calculate_current_total
    expect(@system.current_total).to eq 5.76
  end
end
