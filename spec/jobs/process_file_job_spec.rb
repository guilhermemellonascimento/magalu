# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessFileJob, type: :job do
  let(:file_path) { Rails.root.join('spec/fixtures/files/orders.txt') }
  let(:file_reader) { instance_double(FileReader) }
  let(:line_parser) { instance_double(LineParser) }
  let(:database_handler) { instance_double(DatabaseHandler) }
  let(:order_processor) { instance_double(OrderProcessor) }

  before do
    allow(FileReader).to receive(:new).and_return(file_reader)
    allow(LineParser).to receive(:new).and_return(line_parser)
    allow(DatabaseHandler).to receive(:new).and_return(database_handler)

    allow(OrderProcessor).to receive(:new).and_return(order_processor)
    allow(order_processor).to receive(:call)
  end

  describe '#perform' do
    it 'initializes FileReader with the correct file path' do
      described_class.perform_now(file_path)
      expect(FileReader).to have_received(:new).with(file_path)
    end

    it 'initializes LineParser' do
      described_class.perform_now(file_path)
      expect(LineParser).to have_received(:new)
    end

    it 'initializes DatabaseHandler' do
      described_class.perform_now(file_path)
      expect(DatabaseHandler).to have_received(:new)
    end

    it 'calls OrderProcessor#call once' do
      described_class.perform_now(file_path)
      expect(order_processor).to have_received(:call).once
    end
  end
end
