class City
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 5
  # 城市id
  field :ci, type: Integer
  # 城市名
  field :name, type: String
  # 城市拼音
  field :citypinyin, type: String
  #关联关系
  has_many :merchants, dependent: :delete # 级联删除
end
