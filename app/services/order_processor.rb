# frozen_string_literal: true

class OrderProcessor
  def initialize(file_reader:, line_parser:, database_handler:)
    @file_reader = file_reader
    @line_parser = line_parser
    @database_handler = database_handler
  end

  def call
    @file_reader.each_line do |line|
      next if line.strip.empty?

      attributes = @line_parser.parse(line)
      @database_handler.persist(attributes)
    end
  end
end
