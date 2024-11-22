# spec/queries/user_query_spec.rb
require 'rails_helper'

RSpec.describe UserQuery, type: :query do
  let!(:user1) { create(:user, id: 1) }
  let!(:user2) { create(:user, id: 2) }
  let!(:user3) { create(:user, id: 3) }

  let!(:order1) { create(:order, user: user1, purchase_date: '2024-01-01') }
  let!(:order2) { create(:order, user: user2, purchase_date: '2024-02-01') }
  let!(:order3) { create(:order, user: user3, purchase_date: '2024-03-01') }

  let(:filters) { { start_date: '2024-01-01', end_date: '2024-02-01' } }

  describe '#call' do
    subject { UserQuery.new(filters).call }

    context 'when filtering by id' do
      let(:filters_with_id) { filters.merge(id: 1) }

      subject { UserQuery.new(filters_with_id).call }

      it 'returns the correct user filtered by id' do
        result = subject

        expect(result.count).to eq(1)
        expect(result.map(&:id)).to match_array([1])
      end

      it 'returns an empty list when no user matches the id' do
        filters_with_id[:id] = 999

        result = subject

        expect(result.count).to eq(0)
      end
    end

    context 'when filtering by date range' do
      let(:filters_with_date_range) { filters.merge(start_date: '2024-01-01', end_date: '2024-02-15') }

      subject { UserQuery.new(filters_with_date_range).call }

      it 'applies the date range filter correctly' do
        result = subject

        expect(result.count).to eq(2)
        expect(result.map(&:id)).to match_array([1, 2])
      end

      it 'returns an empty list when no users match the date range' do
        filters_with_date_range[:start_date] = '2024-04-01'
        filters_with_date_range[:end_date] = '2024-04-30'

        result = subject

        expect(result.count).to eq(0)
      end
    end
  end
end
