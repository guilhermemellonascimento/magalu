# frozen_string_literal: true

module Api
  module V1
    class FilesController < ApplicationController
      skip_before_action :verify_authenticity_token

      # POST /api/v1/files/import
      def import
        if params[:file].present?
          file_path = save_file(params[:file])
          ImportFileJob.perform_later(file_path.to_s)

          render json: { message: 'File received successfully!' }, status: :ok
        else
          render json: { error: 'No file was sent.' }, status: :unprocessable_entity
        end
      end

      private

      def save_file(file)
        file_path = Rails.root.join('tmp', file.original_filename)
        File.open(file_path, 'wb') { |f| f.write(file.read) }
        file_path
      end
    end
  end
end
