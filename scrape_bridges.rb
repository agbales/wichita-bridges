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

  got_coords = false

  if links['NBI report']
    nbi = links['NBI report']
    report = "https://bridgereports.com" + nbi
    report_html = open(report)
    sleep 1 until report_html
    r = Nokogiri::HTML(report_html)

    lat = r.css('span.latitude').text.strip.to_f
    long = r.css('span.longitude').text.strip.to_f
    puts lat, long
    got_coords = true
  else
    got_coords = true
  end

  sleep 1 until got_coords == true

  bridges.push(
    links: links,
    latitude: lat,
    longitude: long,
    carries: cells[1].text,
    crosses: cells[2].text,
    location: cells[3].text,
    design: cells[4].text,
    status: cells[5].text,
    year_build: cells[6].text.to_i,
    year_recon: cells[7].text,
    span_length: cells[8].text.to_f,
    total_length: cells[9].text.to_f,
    condition: cells[10].text,
    suff_rating: cells[11].text.to_f,
    id: cells[12].text.to_i
  )
  puts bridges
end

json = JSON.pretty_generate(bridges)
File.open("wichita_bridge_data.json", 'w') { |file| file.write(json) }
