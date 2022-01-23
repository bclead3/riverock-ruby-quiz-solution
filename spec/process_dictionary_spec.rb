# frozen_string_literal: true

require 'process_dictionary'

RSpec.describe 'ProcessDictionary' do
  let(:subject) { ProcessDictionary.new('spec/data/words') }

  describe 'initialize file_path and file' do
    it 'initialize instance variable file' do
      expect(subject.file_path).to eq('spec/data/words')
    end
  end

  describe 'initialize file_path and .gz file' do
    let(:subject) { ProcessDictionary.new('words.tar.gz') }

    it 'recognizes .gz file' do
      expect(subject.file_path).to eq('words.tar.gz')
      file = File.open(subject.file_path)
      expect(subject.file.path).to eq(file.path)
    end
  end

  describe '#extract_array' do
    it 'runs extract_array on sample words file' do
      expected_arr = %w[arrows carrots give me]
      expect(subject.extract_array).to eq(expected_arr)
    end

    describe '#extract_array from .gz file' do
      let(:subject) { ProcessDictionary.new('words.tar.gz') }

      it 'runs extract_array on sample words file' do
        expected_array_size = 25_143
        expect(subject.extract_array.size).to eq(expected_array_size)
      end
    end
  end

  describe '#process_array_from_file' do
    it 'builds sorted hash of four-character words' do
      expected_arr_size = 6
      expected_arr = [["carr", {:answer=>"carrots", :valid=>true}],
                      ["give", {:answer=>"give", :valid=>true}],
                      ["rots", {:answer=>"carrots", :valid=>true}],
                      ["rows", {:answer=>"arrows", :valid=>true}],
                      ["rrot", {:answer=>"carrots", :valid=>true}],
                      ["rrow", {:answer=>"arrows", :valid=>true}]]
      subject_arr = subject.extract_array
      expect(subject.process_array_from_file(subject_arr).size).to eq(expected_arr_size)
      expect(subject.process_array_from_file(subject_arr)).to eq(expected_arr)
    end
  end

  describe '#find_base_dir' do
    it 'private method #find_base_dir' do
      expected_path = 'spec/data/'
      expect(subject.send(:find_base_dir)).to eq(expected_path)
    end

    describe '#find_base_dir for gz file at the base of the project directory' do
      let(:subject) { ProcessDictionary.new('words.tar.gz') }

      it 'private method #find_base_dir' do
        expected_path = './'
        expect(subject.send(:find_base_dir)).to eq(expected_path)
      end
    end

    describe '#find_base_dir for gz file at the base of the project directory' do
      let(:subject) { ProcessDictionary.new('./words.tar.gz') }

      it 'private method #find_base_dir' do
        expected_path = './'
        expect(subject.send(:find_base_dir)).to eq(expected_path)
      end
    end
  end

  describe '#question_array' do
    it 'test with spec/data/words' do
      expected_output = %w[carr give rots rows rrot rrow]
      str_array = subject.extract_array
      full_array = subject.process_array_from_file(str_array)
      expect(subject.question_array(full_array)).to eq(expected_output)
    end
  end

  describe '#answer_array' do
    it 'test with spec/data/words' do
      expected_output = %w[carrots give carrots arrows carrots arrows]
      str_array = subject.extract_array
      full_array = subject.process_array_from_file(str_array)
      expect(subject.answer_array(full_array)).to eq(expected_output)
    end
  end
end
