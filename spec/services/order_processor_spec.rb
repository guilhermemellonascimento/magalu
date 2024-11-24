# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderProcessor, type: :service do
  subject(:order_processor) do
    described_class.new(file_reader: file_reader, line_parser: line_parser, database_handler: database_handler)
  end

  let(:file_reader) { instance_double(FileReader) }
  let(:line_parser) { instance_double(LineParser, parse: parsed_attributes) }
  let(:database_handler) { instance_double(DatabaseHandler) }

  let(:parsed_attributes) do
    {
      user_id: 70,
      name: 'Palmer Prosacco',
      order_id: 753,
      product_id: 3,
      product_value: 1836.74,
      purchase_date: Date.new(2021, 3, 8)
    }
  end

  before do
    allow(file_reader).to receive(:each_line).and_yield('valid line')
    allow(database_handler).to receive(:persist)
  end

  describe '#call' do
    context 'when the file contains lines' do
      it 'calls persist with the parsed attributes for each non-empty line' do
        order_processor.call
        expect(database_handler).to have_received(:persist).with(parsed_attributes).once
      end
    end

    context 'when the file contains empty lines' do
      it 'does not call persist for empty lines' do
        allow(file_reader).to receive(:each_line).and_yield('valid line').and_yield('')
        order_processor.call
        expect(database_handler).to have_received(:persist).with(parsed_attributes).once
      end
    end
  end
end
