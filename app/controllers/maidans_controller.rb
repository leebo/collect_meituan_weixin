class MaidansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_maidan, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
    @maidans = Maidan.all.page params[:page]
    # 搜索
    @maidans = @maidans.where(merchant_id: params[:merchant_id]) unless params[:merchant_id].blank?
    @maidans = @maidans.page params[:page]
  end

  def show
  end

  def new
    @maidan = Merchant.first.maidans.build
  end

  def edit
  end

  def create
    @maidan = Merchant.first.maidans.build(maidan_params)

    respond_to do |format|
      if @maidan.save
        format.html { redirect_to @maidan, notice: 'Maidan was successfully created.' }
        format.json { render :show, status: :created, location: @maidan }
      else
        format.html { render :new }
        format.json { render json: @maidan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @maidan.update(maidan_params)
        format.html { redirect_to @maidan, notice: 'Maidan was successfully updated.' }
        format.json { render :show, status: :ok, location: @maidan }
      else
        format.html { render :edit }
        format.json { render json: @maidan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @maidan.destroy
    respond_to do |format|
      format.html { redirect_to maidans_url, notice: 'Maidan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_maidan
      @maidan = Maidan.find(params[:id])
    end

    def maidan_params
      params.require(:maidan).permit(:content)
    end
end
