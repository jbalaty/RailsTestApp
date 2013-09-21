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

  def extract_search_page_info(url, page)
    result = {}
    nodes = page.search('#results #showOnMap p span')
    result['foundCount'] = nodes[0].content.match(/(?<count>[\d ]+)/)['count'].to_i
    nodes = page.search('#changingResults .result h3.fn a')
    result['lastAdId'] = extract_detail_page_externid nodes[0]['href']
    result
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


end