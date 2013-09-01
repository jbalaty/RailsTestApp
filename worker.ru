# encoding:UTF-8
require 'mechanize'
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


ads = Request.all
ads.each do |item|
  begin
    puts "Item url: #{item.url}"
    page = agent.get(item.url)
    detail = extract_detail_page_data page
    puts detail
    ad = Ad.new
    ad.title = detail['Název']
    ad.price = detail['Celková cena']
    ad.description = detail['Popis']
    ad.externid = detail['ID zakázky']
    ad.updatedAt = detail['Datum aktualizace']
    ad.externsource = 'sreality.cz'
    ad.url = item.url
    ad.save
    puts ad.errors.inspect

  rescue Exception => e
    puts e
  end
end


