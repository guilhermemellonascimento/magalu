# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSerializer, type: :serializer do
  subject { described_class.new(product) }

  let(:user) { create(:user) }
  let(:order) { create(:order, user: user, purchase_date: Date.new(2024, 11, 21)) }
  let(:product) { create(:product, order: order, product_id: 123, value: 45.678) }
  let(:serialized_product) { JSON.parse(subject.to_json) }

  describe 'serialized attributes' do
    it 'includes the product_id' do
      expect(serialized_product['product']['product_id']).to eq(123)
    end

    it 'formats the value as a string with two decimal places' do
      expect(serialized_product['product']['value']).to eq('45.68')
    end
  end
end
