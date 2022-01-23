# frozen_string_literal: true

require 'rubygems/package'
require 'zlib'
require 'byebug'

class ProcessDictionary
  attr_reader :file_path, :file

  EXTENSION_GZIP = '.gz'
  NEWLINE_CHAR = "\n"

  def initialize(file_path)
    @file_path = file_path
    @file = File.open(@file_path)
  end

  def extract_array
    if File.extname(@file_path) == EXTENSION_GZIP
      tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(@file_path))
      tar_extract.rewind
      find_array_from_gzip(tar_extract)
    else
      @file.read.split(NEWLINE_CHAR)
    end
  end

  def process(str_arr)
    dictionary_h = {}
    str_arr.each do |entry|
      sub_file_iterate(entry, dictionary_h) if entry.length >= 4
    end
    # output array of arrays, where each array element has two elements
    # e.g. [ 'valu', { answer: 'value', valid: true } ]
    dictionary_h.select { |_k, v| v[:valid] == true }.sort
  end

  def sub_file_iterate(str, dictionary_h)
    str = str.gsub(/[0-9]/, '').gsub("'", '').gsub('.', '')
    str_len = str.length
    return {} if str.nil? || str_len < 4

    str_stop = str_len - 4
    str_arr = str.chars
    assign_to_dictionary(dictionary_h, str, str_arr, str_stop)
    dictionary_h
  end

  private

  def assign_to_dictionary(dictionary_h, str, str_arr, str_stop)
    (0..str_stop).each do |idx|
      four_char_str = str_arr[idx..(idx + 3)].join.downcase
      if dictionary_h[four_char_str]
        dictionary_h[four_char_str][:valid] = false
        dictionary_h[four_char_str][str] = str
      else
        dictionary_h[four_char_str] = { answer: str, valid: true }
      end
    end
  end

  def find_array_from_gzip(tar_extract)
    ret_str = nil
    tar_extract.each do |entry|
      if entry.full_name == 'words' && entry.file?
        ret_str = entry.read
        return ret_str.split(NEWLINE_CHAR)
      end
    end
  end
end
