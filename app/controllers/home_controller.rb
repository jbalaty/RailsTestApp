# coding: utf-8
require_relative '../../lib/workers/http_tool.rb'
require_relative '../../lib/workers/sreality.rb'


class HomeController < ApplicationController
  def index
    #@messages = []
    #@messages.push request.method
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
Chyba bude zřejmě na naší straně, prosíme Vás tedy o zaslaní této adresy na naši
emailovou adresu <a href=\"mailto:zakaznicky.servis@pcin.cz\">zakaznicky.servis@pcin.cz. Pokusíme to co nejrychleji vyřešit. Děkujeme"
        else
          @summary = 'Počet nalezených inzerátů: '+page_info['total'].to_s + " (Cena "+(page_info['total']/50).to_s+")"
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
