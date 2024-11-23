# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportFileJob, type: :job do
  let(:file_path) { 'path/to/test_file.txt' }
  let(:importer_instance) { instance_double(OrderImporter) }

  before do
    allow(OrderImporter).to receive(:new).with(file_path).and_return(importer_instance)
    allow(importer_instance).to receive(:call)
  end

  describe '#perform' do
    it 'initializes the OrderImporter with the correct file path' do
      described_class.perform_now(file_path)

      expect(OrderImporter).to have_received(:new).with(file_path)
    end

    it 'calls the OrderImporter#call method' do
      described_class.perform_now(file_path)

      expect(importer_instance).to have_received(:call)
    end
  end
end
