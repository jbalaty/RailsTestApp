# encoding:UTF-8

class Sreality
  def initialize

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
    URI::HTTP.build(host:uri.host,path:uri.path)
  end

  def get_url_type(url)
    type = url.match(/sreality.cz\/(?<type>\w+)/)['type']
    if type == 'detail'
      :detail
    elsif type == 'hledani'
      :search
    end
  end

  protected
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
end