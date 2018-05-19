require 'open-uri'
require 'nokogiri'
require 'json'

nbi = "/1201069"
url = 'https://bridgereports.com' + nbi
html = open(url)

r = Nokogiri::HTML(html)

lat = r.css('span.latitude').text
long = r.css('span.longitude').text

puts lat, long