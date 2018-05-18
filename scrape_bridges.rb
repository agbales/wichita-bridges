require 'open-uri'
require 'nokogiri'
require 'json'

url = 'https://bridgereports.com/city/wichita-kansas/'
html = open(url)

doc = Nokogiri::HTML(html)
bridges = []
table = doc.at('table')


table.search('tr').each do |tr|
  cells = tr.search('th, td')
  links = {}
  cells[0].css('a').each do |a|
    links[a.text] = a['href']
  end
  
  bridges.push(
    links: links,
    carries: cells[1].text,
    crosses: cells[2].text,
    location: cells[3].text,
    design: cells[4].text,
    status: cells[5].text,
    year_build: cells[6].text.to_i,
    year_recon: cells[7].text,
    span_length: cells[8].text.to_f,
    total_length: cells[9].text.to_f,
    considtion: cells[10].text,
    suff_rating: cells[11].text.to_f,
    id: cells[12].text.to_i
  )
end

json = JSON.pretty_generate(bridges)
File.open("wichita_bridge_data.json", 'w') { |file| file.write(json) }
