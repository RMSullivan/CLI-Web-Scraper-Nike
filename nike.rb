require 'HTTParty'
require 'Nokogiri'
require 'byebug'

class Scraper

attr_accessor :parse_page

  def initialize
    doc = HTTParty.get("https://store.nike.com/us/en_us/pw/womens-lifestyle-shoes/7ptZoneZoi3")
    @parse_page ||= Nokogiri::HTML(doc) #memorized the @parse_page so it only gets assigned once
  end

  def get_names
  item_container.css(".product-name").css("p").children.map { |name| name.text }.compact
end

  def get_prices
  item_container.css(".product-price").css("span.local").children.map { |price| price.text}.compact
  end

  private

  def item_container
    parse_page.css(".grid-item-info")
  end

  scraper = Scraper.new
  names = scraper.get_names
  prices = scraper.get_prices

  (0...prices.size).each do |index| #three dots don't include the last digit. Will behave like 0...image_links -1
    puts "- - - index: #{index + 1} - - -"
    puts "Name: #{names[index]} | price: #{prices[index]}"
  end
end
