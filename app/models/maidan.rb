class Maidan
  include Mongoid::Document
  include Mongoid::Timestamps
  # 买单内容
  field :content, type: String
  # 关联关系
  belongs_to :merchant
end
