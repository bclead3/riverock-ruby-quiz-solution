# frozen_string_literal: true

require 'rubygems/package'
require 'zlib'
require 'byebug'

class ProcessDictionary
  attr_reader :file_path, :file

  def initialize(file_path)
    @file_path = file_path
    @file = File.open(@file_path)
  end

  def extract_array
    if File.extname(@file_path) == '.gz'
      tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(@file_path))
      tar_extract.rewind
      ret_str = nil
      tar_extract.each do |entry|
        if entry.full_name == 'words' && entry.file?
          ret_str = entry.read
          return ret_str.split("\n")
        end
      end
    else
      @file.read.split("\n")
    end
  end
end
