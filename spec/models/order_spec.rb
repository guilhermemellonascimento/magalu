# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end

  describe '#total_value' do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user) }

    before do
      create(:product, order: order, value: 100.50)
      create(:product, order: order, value: 200.25)
    end

    it 'calculates the total value of all products' do
      expect(order.total_value).to eq(300.75)
    end

    it 'returns 0 when there are no products' do
      order.products.destroy_all
      expect(order.total_value).to eq(0)
    end
  end
end
