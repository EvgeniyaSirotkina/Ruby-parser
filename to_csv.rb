require 'csv'

class ToCsv

   def initialize file_name
	# file name validation
	@file_name = file_name.slice(/.csv/).nil? ? file_name + ".csv" : file_name
	#if file_name.slice(/.csv/).nil?
	#   @file_name = file_name + ".csv"
	#else
	#   @file_name = file_name
	#end
   end

   def write_to_file products
	puts "Started writing to file"
	CSV.open(@file_name, "w", write_headers: true) do |csv|
  	   products.flatten.each do |product|
              csv << product.values
	   end
        end
        puts "Data recorded into file #{@file_name}"
   end

end
