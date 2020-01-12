require 'curb'
require 'nokogiri'
require_relative 'to_csv'

class ParserProducts

   PRODUCT_LIST = "//ul[@id='product_list']"
   PRODUCT_LINK = "//a[@class='product_img_link product-list-category-img']/@href"
   RADIO = "//ul[@class='attribute_radio_list']/li/label"
   PRODUCT_TITLE = "//h1[@class='product_main_name']/text()"
   PRODUCT_IMAGE = "//img[@id='bigpic']/@src"
   PRODUCT_WEIGTH = "./span[@class='radio_label']/text()"
   PRODUCT_PRICE = "./span[@class='price_comb']/text()"

   def initialize url
	@url = url
   end

   def get_links
	puts "I'm looking for all products on page"
	links = []
	params = ""
	page = 1
	loop do
	   doc = Nokogiri::HTML(Curl.get(@url + params).body_str)
	   page += 1
	   params = "?p=#{page}"
	   break if doc.xpath(PRODUCT_LIST).to_s == ""
	   doc.xpath(PRODUCT_LINK).each do |a|
	      links << a.to_s
	   end
	end
	pages = page > 3 ? "#{page - 2} pages" : "1 page"
	puts "Finished. Processed " + pages
	return links
   end

   def parse_page file_name
	links = get_links
	puts "I found #{links.size()} products"
	print "Work progress "
	products = []
	links.each do |a|
	   doc = Nokogiri::HTML(Curl.get(a).body_str)
	   title = doc.xpath(PRODUCT_TITLE).to_s
	   doc.xpath(RADIO).each do |item|
	      full_title = title + " - " + item.xpath(PRODUCT_WEIGTH).to_s
	      products.push(
		title: full_title,
		price: item.xpath(PRODUCT_PRICE).to_s.chomp("€/u").strip,
		image: doc.xpath(PRODUCT_IMAGE),
	      );
	   end	
	   print "."
	end
	puts
	ToCsv.new(file_name).write_to_file(products)
   end

end
