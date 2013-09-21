# encoding:UTF-8
require 'uri'
require 'pathname'

require_relative 'config/environment.rb'
require_relative 'lib/workers/http_tool.rb'
require_relative 'lib/workers/sreality.rb'

requests_per_second = 100;
dt = DateTime.now - 0.minutes
@http_tool = HttpTool.new

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
  sreality = Sreality.new @http_tool
  page = http_tool.get si.urlNormalized
  extractedsi = sreality.extract_search_page_info(si.urlNormalized, page)
  if si.resultsCount != extractedsi['foundCount'] or si.lastExternId != extractedsi['lastAdId']
    changed = true
  end
  si.resultsCount = extractedsi['foundCount']
  si.lastExternId = extractedsi['lastAdId']
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
    sreality = Sreality.new @http_tool
    type = sreality.get_url_type r.url
    if type == :search
      urln = sreality.normalize_search_page_url(r.url).to_s
      #si = WatchedResource.where('externid=:eid', eid: urln).first
      si = WatchedResource.find_by_externId urln
      unless si
        puts 'Creating new WatchedResource'
        si = WatchedResource.new()
        si.urlNormalized = urln
        update_search_info si
        si.save!
      end
      # check if we have watched resource is associated with this request
      unless r.watched_resources.include?(si)
        puts 'Associating new Search info to this request'
        r.watched_resources << si
      end
    elsif type == :detail
      puts 'Type Ad is not implemented yet'
      #externid = sreality.extract_detail_page_externid r.url
      #ad = Ad.find_by_externid externid
      #unless ad
      #  puts 'Creating new ad'
      #  ad = Ad.new()
      #  ad.url = sreality.normalize_detail_page_url(r.url).to_s
      #  update_ad ad
      #  ad.save!
      #end
      #unless r.ads.include?(ad)
      #  puts "Associating existing ad to this request"
      #  r.ads << ad
      #end
    else
      raise new Exception 'Unknown request type'
    end
    r.processed = true
    r.save!
  rescue Mechanize::ResponseCodeError => e
    puts e
    r.addFailedAttempt
    r.save!
      # todo: if more than 10 attempts fail, delete this request
  rescue Exception => e
    puts e
    r.addFailedAttempt
    r.save!
  end
end


#puts_divider
#puts "Processing search infos"
#puts_divider
#puts "Getting SearchInfo with last check before #{dt}"
#sis = SearchInfo.where('lastCheckAt <= ? or lastCheckAt is null', dt)
#sis.each do |si|
#  begin
#    puts "Search info url: #{si.url}"
#    is_changed = update_search_info si
#    si.save!
#    if is_changed
#      puts "Search info with ID=#{si.id} has changed"
#      si.requests.each do |r|
#        puts "\tAcknowlidging owner of request #{r.id} - #{r.email}"
#      end
#    else
#      puts "Searchinfo with ID=#{si.id} was not changed"
#    end
#  rescue Exception => e
#    puts e
#  end
#  sleep 1 / requests_per_second
#end
#
#puts_divider
#puts "Processing ads"
#puts_divider
#puts "Getting Ads with last check before #{dt}"
#ads = Ad.where('lastCheckAt <= ? or lastCheckAt is null', dt)
#ads.each do |ad|
#  begin
#    puts "Ad url: #{ad.url}"
#    is_changed = update_ad ad
#    ad.save!
#    if is_changed
#      puts "Ad with ID=#{ad.id} has changed (#{ad.updatedAt}"
#      ad.requests.each do |r|
#        puts "\tAcknowlidging owner of request #{r.id} - #{r.email}"
#      end
#    else
#      puts "Ad with ID=#{ad.id} was not changed"
#    end
#  rescue Exception => e
#    puts e
#  end
#  sleep 1 / requests_per_second
#end


