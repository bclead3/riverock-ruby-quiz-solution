#! ruby

require './lib/process_dictionary'
ARGV.each do |argument|
  puts "argument:#{argument}"
  dictionary_obj = ProcessDictionary.new(argument)
  out = dictionary_obj.process
  puts out.first
  puts out.last
end
