class FacilityCapacitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_capacity, only: [:show, :edit, :update, :destroy]

  def destroy
    @capacity.destroy
    respond_to do |format|
      format.html { redirect_to edit_facility_path(@capacity.facility), notice: '発電容量履歴を一件削除しました' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capacity
      @capacity = FacilityCapacity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capacity_params
      params.require(:capacity).permit(:value, :date)
    end
end
