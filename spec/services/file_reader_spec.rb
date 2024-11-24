# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileReader, type: :service do
  let(:file_path) { Rails.root.join('spec/fixtures/files/orders.txt') }

  describe '#each_line' do
    it 'yields each line in the file' do
      file_reader = described_class.new(file_path)
      lines = []

      file_reader.each_line { |line| lines << line.strip }

      expect(lines).to eq(File.read(file_path).split("\n").map(&:strip))
    end
  end
end
