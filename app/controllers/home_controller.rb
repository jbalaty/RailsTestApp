# coding: utf-8
class HomeController < ApplicationController
  def index
    #@messages = []
    #@messages.push request.method
    flash.now[:alert] = nil
    @url = params[:url]
    if request.method == 'POST'
      if @url !~ URI::regexp
        flash.now[:alert] = "Nesprávná url adresa, zkontrolujte, zda-li začíná znaky \"http://\""
      elsif /http:\\\/\\\/www.sreality.cz/i !~ @url
        flash.now[:alert] = "Nesprávná url - můžete zadat pouze adresu vedoucí na server Sreality.cz,
        např. \"http://www.sreality.cz/search?category_type_cb=1&category_main_cb=1...\""
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
