class MonthlySolarsController < ApplicationController
  before_action :authenticate_user!

  def update
    @target_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    @facility = Facility.find(params[:facility_id])
    ms = MonthlySolar.find_or_initialize_by(facility: @facility, month: @target_date.strftime('%Y%m'))
    ms.attributes = monthly_solar_params
    ms.recalculate
    ms.save!
    ms.recalculate_and_save_dependencies!
  end 

  private

  def monthly_solar_params
    params.require(:monthly_solar).permit(:input_kwh, :input_kwh_enabled)
  end
end
