# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::FilesController, type: :controller do
  describe 'POST #import' do
    let(:file) { fixture_file_upload('orders.txt', 'text/plain') }
    let(:file_path) { Rails.root.join('tmp', file.original_filename) }

    context 'when a file is imported' do
      before do
        allow(ProcessFileJob).to receive(:perform_later)

        post :import, params: { file: file }
      end

      it 'saves the file to the correct path' do
        expect(File.exist?(file_path)).to be true
      end

      it 'enqueues the ProcessFileJob with the correct file path' do
        expect(ProcessFileJob).to have_received(:perform_later).with(file_path.to_s)
      end

      it 'returns a response with HTTP status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct success message' do
        expect(response.parsed_body['message']).to eq('File received successfully!')
      end
    end

    context 'when no file is uploaded' do
      before do
        post :import, params: { file: nil }
      end

      it 'returns a response with HTTP status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct error message' do
        expect(response.parsed_body['error']).to eq('No file was sent.')
      end
    end
  end
end
