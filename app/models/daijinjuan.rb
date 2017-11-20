class Daijinjuan
  include Mongoid::Document
  include Mongoid::Timestamps
  # 代金券ID
  field :dealid, type: Integer
  # 图片地址
  field :imgurl, type: String
  # 原价格
  field :originprice, type: Integer
  # 现在价格
  field :price, type: Integer
  # 已售数量
  field :solds, type: Integer
  field :stid, type: String
  # 标题
  field :title, type: String
  # 关联关系
  belongs_to :merchant
end
