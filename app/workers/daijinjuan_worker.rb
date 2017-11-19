class DaijinjuanWorker
  include Sidekiq::Worker
  # 采集商家所对应的代金券信息
  # daijinjuans：所得到的商家代金券集合 merchanid：商家id
  def perform(daijinjuans, merchantid)
    # 循环取得代金券信息
    daijinjuans.each do |daijinjuan|
      # 根据商家id来创建代金券
      Merchant.find(merchantid).daijinjuans.create(dealid: "#{daijinjuan['dealId']}", imgurl: "#{daijinjuan['imgUrl']}", originprice: "#{daijinjuan['originPrice']}", price: "#{daijinjuan['price']}", solds: "#{daijinjuan['solds']}", stid: "#{daijinjuan['stid']}", title: "#{daijinjuan['title']}")
    end
  end
end
