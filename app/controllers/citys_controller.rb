class CitysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_city, only: [:show, :edit, :update, :destroy, :collect]
  layout 'admin'

  def index
    @citys = City.all.page params[:page]
    # 搜索
    @citys = @citys.where(name: params[:name]) unless params[:name].blank?
    @citys = @citys.page params[:page]
  end

  def show
  end
  # 根据城市ID进行采集数据
  def collect
    ci = City.find(params[:id]).ci
    MerchantWorker.perform_async(ci)
    redirect_to citys_path, notice: '数据采集正在进行..........'
  end
  # 采集城市信息
  def collectcity
    CityCollectWorker.perform_async()
    redirect_to citys_path, notice: '城市数据采集正在进行..........'
  end
  # 删除所有城市信息
  def deleteall
    City.destroy_all
    redirect_to citys_path, notice: '数据已经删除!!!'
  end

  def new
    @city = City.new
  end

  def edit
  end

  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to citys_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_city
      @city = City.find(params[:id])
    end

    def city_params
      params.require(:city).permit(:ci, :name, :citypinyin)
    end
end
