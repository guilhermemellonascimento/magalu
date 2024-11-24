# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserQuery, type: :query do
  let!(:user1) { create(:user, id: 1) }
  let!(:user2) { create(:user, id: 2) }
  let!(:user3) { create(:user, id: 3) }

  let(:filters) { { start_date: '2024-01-01', end_date: '2024-02-01' } }

  describe '#call' do
    before do
      create(:order, user: user1, purchase_date: '2024-01-01')
      create(:order, user: user2, purchase_date: '2024-02-01')
      create(:order, user: user3, purchase_date: '2024-03-01')
    end

    context 'when filtering by order id' do
      subject(:service) { described_class.new(filters_with_order_id).call }

      let(:filters_with_order_id) { filters.merge(order_id: 1) }

      it 'returns the correct user filtered by order_id' do
        expect(service.count).to eq(1)
      end

      it 'returns an empty list when no user matches the order_id' do
        filters_with_order_id[:order_id] = 999

        expect(service.count).to eq(0)
      end
    end

    context 'when filtering by date range' do
      subject(:service) { described_class.new(filters_with_date_range).call }

      let(:filters_with_date_range) { filters.merge(start_date: '2024-01-01', end_date: '2024-02-15') }

      it 'applies the date range filter correctly' do
        expect(service.count).to eq(2)
      end

      it 'returns an empty list when no users match the date range' do
        filters_with_date_range[:start_date] = '2024-04-01'
        filters_with_date_range[:end_date] = '2024-04-30'

        expect(service.count).to eq(0)
      end
    end
  end
end
