class FacilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_facility, only: [:show, :edit, :update, :destroy, :set_nearest]
  before_action :fetch_solar_facilities, only: [:new, :edit, :create, :update]

  # GET /facilities
  # GET /facilities.json
  def index
    @facilities = Facility.all
    @facilities.each { |f| f.load_last_capacity }
  end

  # GET /facilities/1
  # GET /facilities/1.json
  def show
  end

  # GET /facilities/new
  def new
    @facility = Facility.new
  end

  # GET /facilities/1/edit
  def edit
  end

  # POST /facilities
  # POST /facilities.json
  def create
    @facility = Facility.new(facility_params)
    @facility.solar_facilities = @solar_facilities

    respond_to do |format|
      if @facility.save
        format.html { redirect_to facilities_url, notice: '発電施設情報を作成しました' }
        format.json { render :show, status: :created, location: @facility }
      else
        format.html { render :new }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facilities/1
  # PATCH/PUT /facilities/1.json
  def update
    @facility.solar_facilities = @solar_facilities
    respond_to do |format|
      if @facility.update(facility_params)
        format.html { redirect_to facilities_url, notice: '発電施設情報を更新しました' }
        format.json { render :show, status: :ok, location: @facility }
      else
        format.html { render :edit }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facilities/1
  # DELETE /facilities/1.json
  def destroy
    @facility.destroy
    respond_to do |format|
      format.html { redirect_to facilities_url, notice: '発電施設情報を削除しました' }
      format.json { head :no_content }
    end
  end

  def set_nearest
    if @facility.latitude.present? && @facility.longitude.present?
      @jma_place = JmaPlace.nearest(@facility.latitude, @facility.longitude)
      @nedo_place = NedoPlace.nearest(@facility.latitude, @facility.longitude)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility
      @facility = Facility.find(params[:id])
      @facility.load_last_capacity
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facility_params
      params.require(:facility).permit(
        :name, :latitude, :longitude, :sales_type, :unit_price, 
        :jma_place_id, :nedo_place_id,
        :capacity_value, :capacity_date, :capacity_unit_count,
        facility_aliases_attributes: [:id, :solar_facility_id, :solar_facility_name, :_destroy],
        facility_projects_attributes: [:id, :shabot_project_name, :shabot_project_category, :_destroy]
      )
    end

    def fetch_solar_facilities
      @solar_facilities = SolarFacility.all
    end
end
