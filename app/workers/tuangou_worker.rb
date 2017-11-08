class TuangouWorker
  include Sidekiq::Worker
  # 商家对应的团购信息采集
  # tuangous：所获得商家对应的团购信息集合 merchanid：商家所对应的id
  def perform(tuangous, merchantid)
  	# 循环取得所有的团购信息
  	tuangous.each do |tuangou|
  		Merchant.find(merchantid).tuangous.create(dealid: "#{tuangou['dealId']}", imgurl: "#{tuangou['imgUrl']}", originprice: "#{tuangou['originPrice']}", price: "#{tuangou['price']}", solds: "#{tuangou['solds']}", stid: "#{tuangou['stid']}", title: "#{tuangou['title']}")
  	end
  end
end