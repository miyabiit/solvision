class FacilityAliasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_facility_alias, only: [:show, :edit, :update, :destroy]

  def create
    @facility.facility_aliases << FacilityAlias.new(solar_facility_id: nil, solar_facility_name: '')
  end

  def destroy
    @facility_alias.destroy
    respond_to do |format|
      format.html { redirect_to edit_facility_path(@facility_alias.facility), notice: 'データ連携設定を一件削除しました' }
      format.json { head :no_content }
    end
  end

  private

    def set_facility_alias
      @facility = Facility.find(params[:facility_id]
      @facility_alias = FacilityAlias.find(params[:id])
    end

    def facility_alias_params
      params.require(:facility_alias).permit(:solar_facility_id, :solar_facility_name)
    end
end
