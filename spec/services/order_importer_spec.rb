# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderImporter, type: :service do
  let(:file_path) { Rails.root.join('spec/fixtures/files/orders.txt') }
  let(:file_content) do
    "0000000070                              Palmer Prosacco00000007530000000003     1836.7420210308\n" \
    '0000000075                                  Bobbie Batz00000007980000000002     1578.5720211116'
  end
  let(:order_importer) { described_class.new(file_path) }

  describe '#call' do
    context 'when the file is valid' do
      before do
        File.write(file_path, file_content)
      end

      it 'imports orders and creates users' do
        expect { order_importer.call }.to change(User, :count).by(2)
      end

      it 'imports orders and creates orders' do
        expect { order_importer.call }.to change(Order, :count).by(2)
      end

      it 'imports orders and creates products' do
        expect { order_importer.call }.to change(Product, :count).by(2)
      end

      context 'when verifying the first order' do
        before { order_importer.call }

        it 'creates the first order' do
          expect(Order.find_by(id: 753)).not_to be_nil
        end

        it 'associates the order with the correct user' do
          expect(Order.find_by(id: 753).user_id).to eq(70)
        end

        it 'adds the correct number of products to the order' do
          expect(Order.find_by(id: 753).products.count).to eq(1)
        end

        it 'adds the correct product details' do
          product = Order.find_by(id: 753).products.first
          expect(product.value).to eq(1836.74)
        end
      end

      context 'when verifying the second order' do
        before { order_importer.call }

        it 'creates the first order' do
          expect(Order.find_by(id: 798)).not_to be_nil
        end

        it 'associates the order with the correct user' do
          expect(Order.find_by(id: 798).user_id).to eq(75)
        end

        it 'adds the correct number of products to the order' do
          expect(Order.find_by(id: 798).products.count).to eq(1)
        end

        it 'adds the correct product details' do
          product = Order.find_by(id: 798).products.first
          expect(product.value).to eq(1578.57)
        end
      end
    end

    context 'when the file is empty' do
      it 'does not create any orders' do
        File.write(file_path, '')

        order_importer = described_class.new(file_path)
        expect { order_importer.call }.not_to(change(Order, :count))
      end
    end

    context 'when an error occurs' do
      # let(:logger_double) { instance_double("Logger") }
      # let(:logger_mock) { double('Rails.logger').as_null_object }

      before do
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error' do
        order_importer = described_class.new(file_path)
        # Mock the logger to track the error logging
        # allow(Rails.logger).to receive(:error)

        # Rails.logger.stub(:error) { 'Error processing line 1: Erro ao processar a linha' }

        # Simulate an error by causing `parse_line` to raise an error
        allow(order_importer).to receive(:parse_line).and_raise(Exception)

        # expect { order_importer.call }.not_to raise_error

        # Expect that the error was logged
        # expect(Rails.logger).to have_received(:error)#.with("Error processing line 1: Erro ao processar a linha")
        expect(Rails.logger).to have_received(:error).with('Expected error message')
      end
    end
  end
end
