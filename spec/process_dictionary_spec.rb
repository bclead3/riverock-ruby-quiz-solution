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
end
