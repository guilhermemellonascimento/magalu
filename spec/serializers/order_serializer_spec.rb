# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderSerializer, type: :serializer do
  subject { described_class.new(order) }

  let(:user) { create(:user) }
  let(:serialized_order) { JSON.parse(subject.to_json) }
  let(:order) { create(:order, user: user, purchase_date: Date.new(2024, 11, 21)) }

  before do
    create(:product, order: order, product_id: 1, value: 50.25)
    create(:product, order: order, product_id: 2, value: 73.20)
  end

  it 'serializes the order ID as order_id' do
    expect(serialized_order['order']['order_id']).to eq(order.id)
  end

  it 'formats the total value with two decimals' do
    expect(serialized_order['order']['total']).to eq('123.45')
  end

  it 'formats the purchase date as yyyy-mm-dd' do
    expect(serialized_order['order']['date']).to eq('2024-11-21')
  end

  it 'serializes products as an array' do
    expect(serialized_order['order']['products']).to be_an(Array)
  end

  it 'includes the correct number of products' do
    expect(serialized_order['order']['products'].size).to eq(2)
  end
end
