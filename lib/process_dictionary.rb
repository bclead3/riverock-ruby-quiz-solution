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

  def process
    output_arr = process_array_from_file(extract_array)
    question_arr = question_array(output_arr)
    answer_arr = answer_array(output_arr)

    q_str = write_question_array(question_arr)
    a_str = write_answer_array(answer_arr)
    [q_str, a_str]
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

  def process_array_from_file(str_arr)
    dictionary_h = {}
    str_arr.each do |entry|
      sub_file_iterate(entry, dictionary_h) if entry.length >= 4
    end
    # output array of arrays, where each array element has two elements
    # e.g. [ 'valu', { answer: 'value', valid: true } ]
    dictionary_h.select { |_k, v| v[:valid] == true }.sort
  end

  def question_array(full_array)
    output_arr = []
    full_array.each do |sub_arr|
      output_arr << sub_arr.first
    end
    output_arr
  end

  def answer_array(full_array)
    output_arr = []
    full_array.each do |sub_arr|
      output_arr << sub_arr[1][:answer]
    end
    output_arr
  end

  def write_array(output_array, file_name)
    full_file_name = "#{find_base_dir}#{file_name}"
    f = File.new(full_file_name, 'w')
    num_elements = output_array.size
    output_array.each do |element|
      f.write("#{element}\n")
    end
    f.close
    "#{num_elements} words written to #{file_name} file"
  end

  def write_question_array(output_array)
    write_array(output_array, 'questions')
  end

  def write_answer_array(output_array)
    write_array(output_array, 'answers')
  end

  private

  def find_base_dir
    if @file_path.index('/')
      last_index = @file_path.reverse.index('/')
      @file_path[0..(@file_path.length - 1 - last_index)]
    else
      './'
    end
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
