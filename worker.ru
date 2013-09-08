# encoding:UTF-8
require 'mechanize'
require 'uri'
require 'pathname'

require_relative 'config/environment.rb'
require_relative 'lib/workers/sreality.rb'

@agent = Mechanize.new
requests_per_second = 100;
dt = DateTime.now - 0.minutes

def puts_divider
  puts '-----------------------------------------------------------------'
end

def update_ad(ad)
  changed = false
  page = @agent.get(ad.url)
  sreality = Sreality.new
  detail = sreality.extract_detail_page_data ad.url, page
  #puts detail
  ad.title = detail['Název']
  ad.price = detail['Celková cena']
  ad.description = detail['Popis']
  ad.externid = detail['ExternId']
  # if something changed, create new AdChange object
  if ad.updatedAt != detail['Datum aktualizace']
    changed = true
  else
  end
  ad.updatedAt = detail['Datum aktualizace']
  ad.externsource = 'sreality.cz'
  ad.lastCheckAt = DateTime.now
  ad.lastCheckResponseStatus = '200'
  changed
end

puts_divider
puts "Processing new requests"
puts_divider
requests = Request.where('processed = :p', p: false)
requests.each do |r|
  begin
    puts r.inspect
    sreality = Sreality.new
    type = sreality.get_url_type r.url
    if type == :detail
      externid = sreality.extract_detail_page_externid r.url
      ad = Ad.find_by_externid externid
      unless ad
        puts 'Creating new ad'
        ad = Ad.new()
        ad.url = sreality.normalize_detail_page_url(r.url).to_s
        update_ad ad
        ad.save!
      end
      unless r.ads.include?(ad)
        puts "Associating existing ad to this request"
        r.ads << ad
      end
    elsif type == :search
      raise "Not implemented"
    end
    r.processed = true
    r.save!
  rescue Exception => e
    puts e
  end
end

puts_divider
puts "Processing ads"
puts_divider
puts "Getting Ads with last check before #{dt}"
ads = Ad.where('lastCheckAt <= ? or lastCheckAt is null', dt)
ads.each do |ad|
  begin
    puts "Ad url: #{ad.url}"
    is_changed = update_ad ad
    ad.save!
    if is_changed
      puts "Ad with ID=#{ad.id} has changed (#{ad.updatedAt}"
      ad.requests.each do |r|
        puts "\tAcknowlidging user of request #{r.id} - #{r.email}"
      end
    else
      puts "Ad with ID=#{ad.id} was not changed"
    end
  rescue Exception => e
    puts e
  end
  sleep 1 / requests_per_second
end


