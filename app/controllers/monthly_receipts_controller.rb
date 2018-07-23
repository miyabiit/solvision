class MonthlyReceiptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_monthly_receipt, only: [:show, :edit, :update, :destroy]

  # GET /monthly_receipts
  # GET /monthly_receipts.json
  def index
    #@monthly_receipts = MonthlyReceipt.all
    today = Date.today
    @year = params[:year].presence&.to_i || today.year
    @month = params[:month].presence&.to_i || today.month
    respond_to do |format|
      format.json do
        @facilities = Facility.all
        @receipts = MonthlyReceipt.where(year_month: Date.new(@year, @month, 1).strftime('%Y%m'))
      end
      format.html do
      end
    end
  end

  # GET /monthly_receipts/new
  def new
    @monthly_receipt = MonthlyReceipt.new
  end

  # GET /monthly_receipts/1/edit
  def edit
  end

  # POST /monthly_receipts
  # POST /monthly_receipts.json
  def create
    @monthly_receipt = MonthlyReceipt.new(monthly_receipt_params)

    respond_to do |format|
      if @monthly_receipt.save
        format.html { redirect_to monthly_receipts_url, notice: '入金実績を作成しました' }
        format.json { render :show, status: :created, location: @monthly_receipt }
      else
        format.html { render :new }
        format.json { render json: @monthly_receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monthly_receipts/1
  # PATCH/PUT /monthly_receipts/1.json
  def update
    respond_to do |format|
      if @monthly_receipt.update(monthly_receipt_params)
        format.html { redirect_to monthly_receipts_url, notice: '入金実績を更新しました' }
        format.json { render :show, status: :ok, location: @monthly_receipt }
      else
        format.html { render :edit }
        format.json { render json: @monthly_receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_all
    @year = params[:year].presence&.to_i
    @month = params[:month].presence&.to_i
    unless @year && @month
      render json: {error: {messages: ['年月が入力されていません']}}, status: :unprocessable_entity
      return
    end

    year_month = Date.new(@year, @month, 1).strftime('%Y%m')

    receipt_params = params[:receipts]
    receipt_params.each do |receipt_param|
      receipt = MonthlyReceipt.find_or_initialize_by(facility_id: receipt_param['facilityId'], year_month: year_month)
      receipt.amount = receipt_param['amount']
      receipt.receipt_date = receipt_param['receiptDate']
      receipt.receipt_from = receipt_param['receiptFrom']
      receipt.save!
    end

    render json: {}, status: :ok
  rescue ActiveRecord::RecordInvalid => ex
    render json: {error: {messages: ex.record.errors.full_mesages}}, status: :unprocessable_entity
  end

  # DELETE /monthly_receipts/1
  # DELETE /monthly_receipts/1.json
  def destroy
    @monthly_receipt.destroy
    respond_to do |format|
      format.html { redirect_to monthly_receipts_url, notice: '入金実績を削除しました' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monthly_receipt
      @monthly_receipt = MonthlyReceipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monthly_receipt_params
      params.require(:monthly_receipt).permit(:facility_id, :year_month, :amount)
    end
end
