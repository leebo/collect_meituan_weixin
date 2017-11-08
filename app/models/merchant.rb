class Merchant
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 5
  # 区域名
  field :areaname, type: String
  # 平均价格
  field :avgprice, type: Integer
  # 平均评分
  field :avgscore, type: Integer
  # 分类名
  field :catename, type: String
  # 分类标签
  field :channel, type: String
  # 城市POI ID
  field :ctpoi, type: String
  # 封面图片
  field :frontimg, type: String
  # 纬度
  field :lat, type: Float
  # 经度
  field :lng, type: Float
  # 商家名称
  field :name, type: String
  # POI ID
  field :poiid, type: Integer
  # 商家地址
  field :address, type: String
  # 商家电话
  field :phone, type: String
  # 关联关系
  belongs_to :city
  has_many :maidans, dependent: :delete # 级联删除
  has_many :daijinjuans, dependent: :delete
  has_many :tuangous, dependent: :delete
end