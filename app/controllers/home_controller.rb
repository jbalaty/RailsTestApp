# coding: utf-8
require_relative '../../lib/workers/http_tool.rb'
require_relative '../../lib/workers/sreality.rb'


class HomeController < ApplicationController
  def index
    #@messages = []
    #@messages.push request.method
    @show_summary = false

    flash.now[:alert] = nil
    @url = params[:url]
    if request.method == 'POST'
      http_tool = HttpTool.new
      sreality = Sreality.new http_tool
      if @url !~ URI::regexp
        flash.now[:alert] = "Nesprávná url adresa, zkontrolujte, zda-li začíná znaky \"http://\""
      elsif sreality.is_url_valid?(@url) == nil
        flash.now[:alert] = "Nesprávná url - můžete zadat pouze adresu vedoucí na server Sreality.cz,
          např. \"http://www.sreality.cz/search?category_type_cb=1&category_main_cb=1...\""
      else
        page_info = sreality.get_page_summary(@url)
        unless page_info
          flash.now[:alert] = "Bohužel náš systém nebyl schopen tuto adresu zpracovat.
Chyba bude zřejmě na naší straně a nejsme schopni ji vyřešit ihned. Ale uložili jsme si ji a náš
team se jí bude co nejdříve zabývat."
        else
          @show_summary = true
          @count = page_info['total']
        end
      end
    end
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        format.html { render action: 'index', notice: 'Sledování vytvořeno.' }
      else
        format.html { render action: 'index' }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:request).permit(:title, :url)
  end
end
