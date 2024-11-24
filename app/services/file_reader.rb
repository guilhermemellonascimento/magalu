# frozen_string_literal: true

class FileReader
  def initialize(file_path)
    @file_path = file_path
  end

  def each_line(&)
    File.foreach(@file_path, &)
  end
end
