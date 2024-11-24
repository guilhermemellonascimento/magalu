# frozen_string_literal: true

class ProcessFileJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    file_reader = FileReader.new(file_path)
    line_parser = LineParser.new
    database_handler = DatabaseHandler.new

    OrderProcessor.new(
      file_reader: file_reader,
      line_parser: line_parser,
      database_handler: database_handler
    ).call
  end
end
