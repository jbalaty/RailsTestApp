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
  ad.price = detail['Celková cena'] || detail['Zlevněno']
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

def update_search_info(si)
  changed = false
  sreality = Sreality.new
  page = @agent.get si.url
  extractedsi = sreality.extract_search_page_info(si.url, page)
  if si.resultsCount != extractedsi['foundCount'] or si.lastAdExternId != extractedsi['lastAdId']
    changed = true
  end
  si.resultsCount = extractedsi['foundCount']
  si.lastAdExternId = extractedsi['lastAdId']
  si.lastCheckAt = DateTime.now
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
      si = SearchInfo.find_by_url r.url
      unless si
        puts 'Creating new SearchInfo'
        si = SearchInfo.new()
        si.url = sreality.normalize_search_page_url(r.url).to_s
        update_search_info si
        si.save!
      end
      unless r.search_infos.include?(si)
        puts "Associating existing search info to this request"
        r.search_infos << si
      end
    end
    r.processed = true
    r.save!
  rescue Mechanize::ResponseCodeError => e
    puts e
    r.failedAttempts += 1
    r.save!
    # todo: if more than 10 attempts fail, delete this request
  rescue Exception => e
    puts e
  end
end


puts_divider
puts "Processing search infos"
puts_divider
puts "Getting SearchInfo with last check before #{dt}"
sis = SearchInfo.where('lastCheckAt <= ? or lastCheckAt is null', dt)
sis.each do |si|
  begin
    puts "Search info url: #{si.url}"
    is_changed = update_search_info si
    si.save!
    if is_changed
      puts "Search info with ID=#{si.id} has changed"
      si.requests.each do |r|
        puts "\tAcknowlidging owner of request #{r.id} - #{r.email}"
      end
    else
      puts "Searchinfo with ID=#{si.id} was not changed"
    end
  rescue Exception => e
    puts e
  end
  sleep 1 / requests_per_second
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
        puts "\tAcknowlidging owner of request #{r.id} - #{r.email}"
      end
    else
      puts "Ad with ID=#{ad.id} was not changed"
    end
  rescue Exception => e
    puts e
  end
  sleep 1 / requests_per_second
end


