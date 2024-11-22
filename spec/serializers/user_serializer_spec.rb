# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  subject { described_class.new(user) }

  let(:user) { create(:user, id: 1, name: 'John Doe') }
  let(:serialized_user) { JSON.parse(subject.to_json) }

  before do
    create_list(:order, 2, user: user)
  end

  describe 'serialized attributes' do
    it 'includes the user_id' do
      expect(serialized_user['user']['user_id']).to eq(1)
    end

    it 'includes the name' do
      expect(serialized_user['user']['name']).to eq('John Doe')
    end
  end

  describe 'associated orders' do
    it 'includes orders as an array' do
      expect(serialized_user['user']['orders']).to be_an(Array)
    end

    it 'serializes all associated orders' do
      expect(serialized_user['user']['orders'].size).to eq(2)
    end
  end
end
