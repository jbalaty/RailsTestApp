class AdInfosController < ApplicationController
  before_action :set_ad_info, only: [:show, :edit, :update, :destroy]

  # GET /ad_infos
  # GET /ad_infos.json
  def index
    @ad_infos = AdInfo.all
  end

  # GET /ad_infos/1
  # GET /ad_infos/1.json
  def show
  end

  # GET /ad_infos/new
  def new
    @ad_info = AdInfo.new
  end

  # GET /ad_infos/1/edit
  def edit
  end

  # POST /ad_infos
  # POST /ad_infos.json
  def create
    @ad_info = AdInfo.new(ad_info_params)

    respond_to do |format|
      if @ad_info.save
        format.html { redirect_to @ad_info, notice: 'Ad info was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ad_info }
      else
        format.html { render action: 'new' }
        format.json { render json: @ad_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ad_infos/1
  # PATCH/PUT /ad_infos/1.json
  def update
    respond_to do |format|
      if @ad_info.update(ad_info_params)
        format.html { redirect_to @ad_info, notice: 'Ad info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ad_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_infos/1
  # DELETE /ad_infos/1.json
  def destroy
    @ad_info.destroy
    respond_to do |format|
      format.html { redirect_to ad_infos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad_info
      @ad_info = AdInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ad_info_params
      params.require(:ad_info).permit(:externid, :urlNormalized)
    end
end
