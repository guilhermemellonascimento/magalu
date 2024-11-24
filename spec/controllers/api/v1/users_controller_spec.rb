# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:order1) { create(:order, user: user1) }
    let(:order2) { create(:order, user: user2) }

    before do
      create(:product, order: order1)
      create(:product, order: order2)
    end

    context 'when fetching the list of users' do
      before do
        get :index
      end

      it 'returns a success HTTP status' do
        expect(response).to have_http_status(:success)
      end

      it 'includes the name of user1 in the response body' do
        expect(response.body).to include(user1.name)
      end

      it 'includes the name of user2 in the response body' do
        expect(response.body).to include(user2.name)
      end
    end

    context 'when checking the response structure for orders and products' do
      before do
        get :index
      end

      it 'includes orders as an array for the first user' do
        json_response = response.parsed_body
        expect(json_response[0]['orders']).to be_an(Array)
      end

      it 'includes orders as an array for the second user' do
        json_response = response.parsed_body
        expect(json_response[1]['orders']).to be_an(Array)
      end

      it 'includes products as an array for the first order of the first user' do
        json_response = response.parsed_body
        expect(json_response[0]['orders'][0]['products']).to be_an(Array)
      end

      it 'includes products as an array for the first order of the second user' do
        json_response = response.parsed_body
        expect(json_response[1]['orders'][0]['products']).to be_an(Array)
      end
    end

    context 'when pagination is applied' do
      before do
        get :index, params: { page: 1, per_page: 2 }
      end

      it 'returns the correct number of users on the current page' do
        json_response = response.parsed_body
        expect(json_response.count).to eq(2)
      end

      it 'returns the correct user IDs for the current page' do
        json_response = response.parsed_body
        user_ids = json_response.pluck('user_id')
        expect(user_ids).to contain_exactly(1, 2)
      end
    end
  end
end
