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
end
