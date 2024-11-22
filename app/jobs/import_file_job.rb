# frozen_string_literal: true

class ImportFileJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    OrderImporter.new(file_path).call
  end
end
