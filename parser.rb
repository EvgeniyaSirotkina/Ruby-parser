require_relative 'parser_products'

path = ARGV[0]
file_name = ARGV[1]

puts "I got data:"
puts "\tURL: #{path}"
puts "\tFile to save: #{file_name}"

ParserProducts.new(path).parse_page(file_name)


