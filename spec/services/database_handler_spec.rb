# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatabaseHandler, type: :service do
  let(:database_handler) { described_class.new }

  describe '#persist' do
    let(:user_id) { 70 }
    let(:user_name) { 'Palmer Prosacco' }
    let(:order_id) { 753 }
    let(:purchase_date) { Date.new(2021, 3, 8) }
    let(:product_id) { 1001 }
    let(:product_value) { 1836.74 }
    let(:attributes) do
      {
        user_id: user_id,
        name: user_name,
        order_id: order_id,
        purchase_date: purchase_date,
        product_id: product_id,
        product_value: product_value
      }
    end

    context 'when a user does not exist' do
      it 'creates a new user' do
        expect { database_handler.persist(attributes) }.to change(User, :count).by(1)
      end

      it 'assigns the correct name to the user' do
        database_handler.persist(attributes)
        user = User.find(user_id)
        expect(user.name).to eq(user_name)
      end
    end

    context 'when a user already exists' do
      before { User.create!(id: user_id, name: user_name) }

      it 'does not create a new user' do
        expect { database_handler.persist(attributes) }.not_to change(User, :count)
      end
    end

    context 'when an order does not exist' do
      it 'creates a new order' do
        expect { database_handler.persist(attributes) }.to change(Order, :count).by(1)
      end

      it 'associates the order with the correct user' do
        database_handler.persist(attributes)
        order = Order.find(order_id)
        expect(order.user_id).to eq(user_id)
      end

      it 'assigns the correct purchase date to the order' do
        database_handler.persist(attributes)
        order = Order.find(order_id)
        expect(order.purchase_date).to eq(purchase_date)
      end
    end

    context 'when an order already exists' do
      before do
        user = User.create!(id: user_id, name: user_name)
        user.orders.create!(id: order_id, purchase_date: purchase_date)
      end

      it 'does not create a new order' do
        expect { database_handler.persist(attributes) }.not_to change(Order, :count)
      end
    end

    context 'when a product does not exist' do
      it 'creates a new product' do
        expect { database_handler.persist(attributes) }.to change(Product, :count).by(1)
      end

      it 'assigns the correct value to the product' do
        database_handler.persist(attributes)
        product = Product.find_by(product_id: product_id)
        expect(product.value).to eq(product_value)
      end

      it 'associates the product with the correct order' do
        database_handler.persist(attributes)
        product = Product.find_by(product_id: product_id)
        expect(product.order_id).to eq(order_id)
      end
    end

    context 'when a product already exists' do
      before do
        user = User.create!(id: user_id, name: user_name)
        order = user.orders.create!(id: order_id, purchase_date: purchase_date)
        order.products.create!(product_id: product_id, value: product_value)
      end

      it 'does not create a new product' do
        expect { database_handler.persist(attributes) }.not_to change(Product, :count)
      end
    end
  end
end
