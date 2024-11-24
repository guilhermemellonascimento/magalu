# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineParser, type: :service do
  let(:line) do
    '0000000070                              Palmer Prosacco00000007530000000003     1836.7420210308'
  end

  describe '#parse' do
    expected_data = {
      user_id: 70,
      name: 'Palmer Prosacco',
      order_id: 753,
      product_id: 3,
      product_value: 1836.74,
      purchase_date: Date.new(2021, 3, 8)
    }
    it 'parses a line into a hash with the correct attributes' do
      parser = described_class.new
      parsed_data = parser.parse(line)

      expect(parsed_data).to eq(expected_data)
    end
  end
end
