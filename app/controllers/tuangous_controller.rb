class TuangousController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tuangou, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
    @tuangous = Tuangou.all.page params[:page]
    # 搜索
    @tuangous = @tuangous.where(merchant_id: params[:merchant_id]) unless params[:merchant_id].blank?
    @tuangous = @tuangous.page params[:page]
  end

  def show
  end
  # 根据原价格升序排序
  def originpriceasc
    @tuangous = Tuangou.all.page params[:page]
    @tuangous = @tuangous.order_by(:originprice.asc)
    render :index
  end
  # 根据原价格降序排序
  def originpricedesc
    @tuangous = Tuangou.all.page params[:page]
    @tuangous = @tuangous.order_by(:originprice.desc)
    render :index
  end
  # 根据现价格升序排序
  def priceasc
    @tuangous = Tuangou.all.page params[:page]
    @tuangous = @tuangous.order_by(:price.asc)
    render :index
  end
  # 根据现价格降序排序
  def pricedesc
    @tuangous = Tuangou.all.page params[:page]
    @tuangous = @tuangous.order_by(:price.desc)
    render :index
  end
  # 根据售出数量升序排序
  def soldsasc
    @tuangous = Tuangou.all.page params[:page]
    @tuangous = @tuangous.order_by(:solds.asc)
    render :index
  end
  # 根据售出数量降序排序
  def soldsdesc
    @tuangous = Tuangou.all.page params[:page]
    @tuangous = @tuangous.order_by(:solds.desc)
    render :index
  end

  # GET /tuangous/new
  def new
    @tuangou = Tuangou.new#current_tuangou.tuangous.build
  end

  def edit
  end

  def create
    @tuangou = Tuangou.new(tuangou_params)

    respond_to do |format|
      if @tuangou.save
        format.html { redirect_to @tuangou, notice: 'Tuangou was successfully created.' }
        format.json { render :show, status: :created, location: @tuangou }
      else
        format.html { render :new }
        format.json { render json: @tuangou.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tuangou.update(tuangou_params)
        format.html { redirect_to @tuangou, notice: 'Tuangou was successfully updated.' }
        format.json { render :show, status: :ok, location: @tuangou }
      else
        format.html { render :edit }
        format.json { render json: @tuangou.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tuangou.destroy
    respond_to do |format|
      format.html { redirect_to tuangous_url, notice: 'Tuangou was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_tuangou
      @tuangou = Tuangou.find(params[:id])
    end

    def tuangou_params
      params.require(:tuangou).permit(:dealid, :imgurl, :originprice, :price, :solds, :stid, :title)
    end
end
