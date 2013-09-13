class SearchInfosController < ApplicationController
  before_action :set_search_info, only: [:show, :edit, :update, :destroy]

  # GET /search_infos
  # GET /search_infos.json
  def index
    @search_infos = SearchInfo.all
  end

  # GET /search_infos/1
  # GET /search_infos/1.json
  def show
  end

  # GET /search_infos/new
  def new
    @search_info = SearchInfo.new
  end

  # GET /search_infos/1/edit
  def edit
  end

  # POST /search_infos
  # POST /search_infos.json
  def create
    @search_info = SearchInfo.new(search_info_params)

    respond_to do |format|
      if @search_info.save
        format.html { redirect_to @search_info, notice: 'Search info was successfully created.' }
        format.json { render action: 'show', status: :created, location: @search_info }
      else
        format.html { render action: 'new' }
        format.json { render json: @search_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /search_infos/1
  # PATCH/PUT /search_infos/1.json
  def update
    respond_to do |format|
      if @search_info.update(search_info_params)
        format.html { redirect_to @search_info, notice: 'Search info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @search_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_infos/1
  # DELETE /search_infos/1.json
  def destroy
    @search_info.destroy
    respond_to do |format|
      format.html { redirect_to search_infos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_info
      @search_info = SearchInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_info_params
      params[:search_info]
    end
end
