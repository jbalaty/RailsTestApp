# encoding:UTF-8
require 'mechanize'
require 'uri'
require 'pathname'
require_relative 'config/environment.rb'

agent = Mechanize.new


def extract_detail_page_data(page)
  result = {}
  nodes = page.search('#realityInfo h2')
  result['Název'] = nodes.first.content
  nodes = page.search('#realityInfo p.row')
  result.merge! extract_rows nodes
  result['Popis'] = page.search('.row.last .description').first.content
  result
end

def extract_rows(nodes)
  result = {}
  value = nil
  nodes.each do |row|
    desc = row.children()[1].content.strip.chop
    case
      when desc == "Celková cena"
        value = row.children()[3].content.match(/(?<price>[\d ]+)/)['price'].gsub(/ /, '').to_i
      when desc == "Datum aktualizace"
        value = Date.parse(row.children()[3].content)
      else
        value = row.children()[3].content
    end
    result[desc]=value
  end
  result
end

def extract_sreality_externid(url)
  return Pathname.new(URI(url).path).basename.to_s
end

pages_per_second = 100;
dt = DateTime.now - 0.minutes
puts "Getting Ads with last check before #{dt}"
ads = Ad.where('lastCheckAt <= ? or lastCheckAt is null', dt)
ads.each do |item|
  begin
    puts "Item url: #{item.url}"
    page = agent.get(item.url)
    detail = extract_detail_page_data page
    #puts detail
    ad = item
    ad.title = detail['Název']
    ad.price = detail['Celková cena']
    ad.description = detail['Popis']
    ad.externid = extract_sreality_externid(item.url) #detail['ID zakázky']
    # if something changed, create new AdChange object
    if ad.updatedAt != detail['Datum aktualizace']
      puts "Ad with ID=#{ad.id} has changed (#{ad.updatedAt} != #{detail['Datum aktualizace']})"
    else
      puts "Ad with ID=#{ad.id} was note updated"
    end
    ad.updatedAt = detail['Datum aktualizace']
    ad.externsource = 'sreality.cz'
    ad.lastCheckAt = DateTime.now
    ad.lastCheckResponseStatus = '200'
    ad.url = item.url
    ad.save!
  rescue Exception => e
    puts e
  end
  sleep 1 / pages_per_second
end


