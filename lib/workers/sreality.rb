# encoding:UTF-8

class Sreality
  def initialize(http_tool)
    @http_tool = http_tool
  end

  def extract_detail_page_data(url, page)
    result = {}
    nodes = page.search('#realityInfo h2')
    result['Název'] = nodes.first.content
    nodes = page.search('#realityInfo p.row')
    result.merge! extract_rows nodes
    result['Popis'] = page.search('.row.last .description').first.content
    result['ExternId'] = extract_detail_page_externid(url)
    result
  end

  def extract_detail_page_externid(url)
    return Pathname.new(URI(url).path).basename.to_s
  end

  def normalize_detail_page_url(url)
    uri = URI(url)
    URI::HTTP.build(host: uri.host, path: uri.path)
  end

  def get_url_type(url)
    type = url.match(/sreality.cz\/(?<type>\w+)/)['type']
    if type == 'detail'
      :detail
    elsif type == 'hledani' or type == 'search'
      :search
    end
  end

  def normalize_search_page_url(url)
    URI url.sub(/sort=\d/, 'sort=0')
  end

  def extract_search_page_info(url)
    result = {}
    page = @http_tool.get set_search_url_query_params(url, 'perPage' => 100)
    nodes = page.search('#results #showOnMap p span')
    result['foundCount'] = nodes.first.content.match(/(?<count>[\d ]+)/)['count'].to_i
    ads = []
    # repeat until we have page with some results
    while page
      nodes = page.search('#changingResults .result.vcard')
      nodes.each do |vcard|
        unless vcard.to_s =~ /\.tip/
          ads << extract_search_page_item(vcard)
        else
          puts "Skipping this node, it is probably SReality payed ad"
        end
      end
      # try to find next page link
      nodes = page.search('#paging a.next')
      if nodes.any?
        page = @http_tool.get nodes.first['href']
      else
        page = nil
      end
    end
    result['ads'] = ads
    result
  end

  def extract_search_page_item(vcard_node)
    nodes = nil
    begin
      result = {}
      result['shortInfoHtml'] = vcard_node.to_s
      nodes = vcard_node.search('.fn a')
      result['title'] = nodes.first.content
      result['urlNormalized'] = normalize_detail_page_url(nodes.first['href']).to_s
      result['externId'] = extract_detail_page_externid(result['urlNormalized'])
      result['externSource'] = 'sreality'
      nodes = vcard_node.search('.price')
      nodes = vcard_node.search('.price-discount') if nodes.empty?
      if nodes.first.content == 'Info o ceně u RK' then
        result['price'] = 0;
        result['priceNotice'] = nodes.first.content if nodes.any?
      else
        result['price'] = nodes.first.content.gsub(/ /, '').to_i
        nodes = vcard_node.search('.price-discount-desc')
        result['priceNotice'] = nodes.first.content if nodes.any?
      end
      nodes = vcard_node.search('.silver')
      result['priceType'] = nodes.first.content if nodes.any?
      nodes = vcard_node.search('.address.adr').children().slice(2..10)
      result['shortAddress'] = nodes.to_a.map { |n| n.content }.join
      nodes = vcard_node.search('.picture.url img')
      result['imageUrl'] = nodes.first['data-src']
      result
    rescue
      puts $!
      puts $!.backtrace.inspect
      puts 'Error parsing item vcard info: ' + vcard_node.inspect
      #puts "Additional node info: #{nodes.first.content}" if nodes.any?
      raise $!
    end
  end

  protected
  def extract_rows(nodes)
    result = {}
    value = nil
    nodes.each do |row|
      desc = row.children()[1].content.strip.chop
      if ['Zlevněno', 'Původní cena', 'Celková cena'].include? desc
        value = row.children()[3].content.match(/(?<price>[\d ]+)/)['price'].gsub(/ /, '').to_i
      elsif desc == 'Datum aktualizace'
        value = Date.parse(row.children()[3].content)
      else
        value = row.children()[3].content
      end
      result[desc]=value
    end
    result
  end

  def set_search_url_query_params(url, hash)
    uri = URI(url)
    params = Rack::Utils.parse_query uri.query
    hash.each do |key, value|
      if params.has_key? key
        params[key] = value
      end
    end
    uri.query = URI.encode_www_form params
    uri.to_s
  end

end