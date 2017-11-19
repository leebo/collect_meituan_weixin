class MerchantWorker
  include Sidekiq::Worker
  # 商家信息采集主Worker
  # ci：传入的城市id
  def perform(ci)
    logger.info ci
    # 从第0条记录开始取
    offset = 0
    # 通过请求获得totalcount总记录数
    response = RestClient.post 'http://meishi.meituan.com/i/api/channel/deal/list', {"offset":0,"limit":15,"cateId":1,"lineId":0,"stationId":0,"areaId":0,"sort":"default","deal_attr_23":"","deal_attr_24":"","deal_attr_25":"","poi_attr_20043":"","poi_attr_20033":""}, {cookie: "ci=#{ci}"}
    totalcount = JSON.parse(response.body)["data"]["poiList"]["totalCount"]

    # 当记录数小于总记录数时继续进行
    while offset < totalcount
      # 取得poiinfos商家信息
      response = RestClient.post 'http://meishi.meituan.com/i/api/channel/deal/list', {"offset": offset,"limit":50,"cateId":1,"lineId":0,"stationId":0,"areaId":0,"sort":"default","deal_attr_23":"","deal_attr_24":"","deal_attr_25":"","poi_attr_20043":"","poi_attr_20033":""}, {cookie: "ci=#{ci}"}
      poiInfos = JSON.parse(response.body)["data"]["poiList"]["poiInfos"]
      poiInfos.each do |poiInfo|
        # 商家对应的买单列表，从0开始，累加
        index = 0
        # 取得merchant商家信息
        merchant = City.find_by(ci: "#{ci}").merchants.create(areaname: "#{poiInfo['areaName']}", avgprice: "#{poiInfo['avgPrice']}", avgscore: "#{poiInfo['avgScore']}", catename: "#{poiInfo['cateName']}", channel: "#{poiInfo['channel']}", ctpoi: "#{poiInfo['ctPoi']}", frontimg: "#{poiInfo['frontImg']}", lat: "#{poiInfo['lat']}", lng: "#{poiInfo['lng']}", name: "#{poiInfo['name']}", poiid: "#{poiInfo['poiid']}")

        # 得到当前商家的id
        merchantid = merchant.id
        # 请求到商家地址，电话信息的页面
        merchantupdate = RestClient.get "http://meishi.meituan.com/i/poi/#{poiInfo['poiid']}?ct_poi=#{poiInfo['ctPoi']}", {cookie: "iuuid=7A180AC0B652BC59B538B5B2B63F6D288046C0345B401B0079FE76518A637FC2; ci=#{ci}"}
        mbody = merchantupdate.body
        # 商家id，商家更新页面body存在，则开始更新商家地址，电话Worker
        if not merchantid.blank? && mbody.blank?
          MerchantUpdateWorker.perform_async(merchantid, mbody)
        end

        # 取得商家对应的买单信息
        maidans = JSON.parse(response.body)["data"]["poiList"]["poiInfos"][index]["preferentialInfo"]["maidan"]["entries"]
        maidans.each do |maidan|
          merchant.maidans.create(content: "#{maidan['content']}")
        end
        index = index + 1

        # 请求获得代金券，团购信息
        deallist = RestClient.post 'https://meishi.meituan.com/i/api/poi/deallist', {"poiId": "#{poiInfo['poiid'].to_i}"}, {cookie: "ci=#{ci}"}
        daijinjuans = JSON.parse(deallist.body)["data"]["voucherArr"]
        tuangous = JSON.parse(deallist.body)["data"]["dealArr"]
        # 代金券，团购不为空时，进行DaijinjuanWorker，TuangouWorker采集
        if not daijinjuans.blank?
          DaijinjuanWorker.perform_async(daijinjuans, merchantid)
        end
        if not tuangous.blank?
          TuangouWorker.perform_async(tuangous, merchantid)
        end
      end
      # 每次取得50条记录
      offset = offset + 50
    end
  end
end
