# frozen_string_literal: true

class ProcessDictionary
  attr_reader :file_path, :file

  def initialize(file_path)
    @file_path = file_path
    @file = File.open(@file_path)
  end
end
