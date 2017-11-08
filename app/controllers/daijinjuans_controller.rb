class DaijinjuansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_daijinjuan, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
    @daijinjuans = Daijinjuan.all.page params[:page]
    # 搜索
    @daijinjuans = @daijinjuans.where(merchant_id: params[:merchant_id]) unless params[:merchant_id].blank?
    @daijinjuans = @daijinjuans.page params[:page]
  end

  def show
  end
  # 根据原价格升序排序
  def originpriceasc
    @daijinjuans = Daijinjuan.all.page params[:page]
    @daijinjuans = @daijinjuans.order_by(:originprice.asc)
    render :index
  end
  # 根据原价格降序排序
  def originpricedesc
    @daijinjuans = Daijinjuan.all.page params[:page]
    @daijinjuans = @daijinjuans.order_by(:originprice.desc)
    render :index
  end
  # 根据现价格升序排序
  def priceasc
    @daijinjuans = Daijinjuan.all.page params[:page]
    @daijinjuans = @daijinjuans.order_by(:price.asc)
    render :index
  end
  # 根据现价格降序排序
  def pricedesc
    @daijinjuans = Daijinjuan.all.page params[:page]
    @daijinjuans = @daijinjuans.order_by(:price.desc)
    render :index
  end
  # 根据售出数量升序排序
  def soldsasc
    @daijinjuans = Daijinjuan.all.page params[:page]
    @daijinjuans = @daijinjuans.order_by(:solds.asc)
    render :index
  end
  # 根据售出数量降序排序
  def soldsdesc
    @daijinjuans = Daijinjuan.all.page params[:page]
    @daijinjuans = @daijinjuans.order_by(:solds.desc)
    render :index
  end

  def new
    @daijinjuan = Daijinjuan.new
  end

  def edit
  end

  def create
    @daijinjuan = Daijinjuan.new(daijinjuan_params)

    respond_to do |format|
      if @daijinjuan.save
        format.html { redirect_to @daijinjuan, notice: 'Daijinjuan was successfully created.' }
        format.json { render :show, status: :created, location: @daijinjuan }
      else
        format.html { render :new }
        format.json { render json: @daijinjuan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @daijinjuan.update(daijinjuan_params)
        format.html { redirect_to @daijinjuan, notice: 'Daijinjuan was successfully updated.' }
        format.json { render :show, status: :ok, location: @daijinjuan }
      else
        format.html { render :edit }
        format.json { render json: @daijinjuan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @daijinjuan.destroy
    respond_to do |format|
      format.html { redirect_to daijinjuans_url, notice: 'Daijinjuan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_daijinjuan
      @daijinjuan = Daijinjuan.find(params[:id])
    end

    def daijinjuan_params
      params.require(:daijinjuan).permit(:dealid, :imgurl, :originprice, :price, :solds, :stid, :title)
    end
end
