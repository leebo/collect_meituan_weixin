class MerchantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_merchant, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
    @merchants = Merchant.all.page params[:page]
    # 模糊搜索
    @merchants = @merchants.where(city_id: City.find_by(name: /#{params[:cityname]}/).id) unless params[:cityname].blank?
    @merchants = @merchants.where(name: /#{params[:name]}/) unless params[:name].blank?
    @merchants = @merchants.where(id: params[:id]) unless params[:id].blank?
    @merchants = @merchants.page params[:page]
  end

  def show
    @maidans = @merchant.maidans
    @daijinjuans = @merchant.daijinjuans
    @tuangous = @merchant.tuangous
  end
  # 删除所有商家信息
  def deleteall
    Merchant.destroy_all
    redirect_to merchants_path, notice: '数据已经删除!!!'
  end
  # 根据平均价格进行升序排序
  def priceasc
    @merchants = Merchant.all.page params[:page]
    @merchants = @merchants.order_by(:avgprice.asc)
    render :index
  end
  # 根据平均价格进行降序排序
  def pricedesc
    @merchants = Merchant.all.page params[:page]
    @merchants = @merchants.order_by(:avgprice.desc)
    render :index
  end
  # 根据平均评分进行升序排序
  def scoreasc
    @merchants = Merchant.all.page params[:page]
    @merchants = @merchants.order_by(:avgscore.asc)
    render :index
  end
  # 根据平均评分进行降序排序
  def scoredesc
    @merchants = Merchant.all.page params[:page]
    @merchants = @merchants.order_by(:avgscore.desc)
    render :index
  end

  def new
    @merchant = Merchant.new#current_user.merchants.build
  end

  def edit
  end

  def create
    @merchant = Merchant.new(merchant_params)

    respond_to do |format|
      if @merchant.save
        format.html { redirect_to @merchant, notice: 'Merchant was successfully created.' }
        format.json { render :show, status: :created, location: @merchant }
      else
        format.html { render :new }
        format.json { render json: @merchant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @merchant.update(merchant_params)
        format.html { redirect_to @merchant, notice: 'Merchant was successfully updated.' }
        format.json { render :show, status: :ok, location: @merchant }
      else
        format.html { render :edit }
        format.json { render json: @merchant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @merchant.destroy
    respond_to do |format|
      format.html { redirect_to merchants_url, notice: 'Merchant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_merchant
      @merchant = Merchant.find(params[:id])
    end

    def merchant_params
      params.require(:merchant).permit(:areaname, :avgprice, :avgscore, :catename, :channel, :ctpoi, :frontimg, :lat, :lng, :name, :poiid, :address, :phone)
    end
end
