class WatchedResourcesController < ApplicationController
  before_action :set_watched_resource, only: [:show, :edit, :update, :destroy]

  # GET /watched_resources
  # GET /watched_resources.json
  def index
    @watched_resources = WatchedResource.all
  end

  # GET /watched_resources/1
  # GET /watched_resources/1.json
  def show
  end

  # GET /watched_resources/new
  def new
    @watched_resource = WatchedResource.new
  end

  # GET /watched_resources/1/edit
  def edit
  end

  # POST /watched_resources
  # POST /watched_resources.json
  def create
    @watched_resource = WatchedResource.new(watched_resource_params)

    respond_to do |format|
      if @watched_resource.save
        format.html { redirect_to @watched_resource, notice: 'Watched resource was successfully created.' }
        format.json { render action: 'show', status: :created, location: @watched_resource }
      else
        format.html { render action: 'new' }
        format.json { render json: @watched_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watched_resources/1
  # PATCH/PUT /watched_resources/1.json
  def update
    respond_to do |format|
      if @watched_resource.update(watched_resource_params)
        format.html { redirect_to @watched_resource, notice: 'Watched resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @watched_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /watched_resources/1
  # DELETE /watched_resources/1.json
  def destroy
    @watched_resource.destroy
    respond_to do |format|
      format.html { redirect_to watched_resources_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watched_resource
      @watched_resource = WatchedResource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def watched_resource_params
      params.require(:watched_resource).permit(:type, :lastCheckAt, :urlNormalized, :usage)
    end
end
