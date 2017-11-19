class MerchantUpdateWorker
  include Sidekiq::Worker
  # 更新商家地址，电话信息
  # merchanid：商家对应的id mbody：商家页面body
  def perform(merchantid,mbody)
    # 通过match加正则找到匹配到的第一个信息
    phone = mbody.match(/phone\":\"(\S*)\",\"lng/)
    addr = mbody.match(/addr\":\"(\S*)\",\"phone/)
    # 判断电话，地址不为空，则取得phone，addr
    if not phone.blank?
      phone = phone[1]
    end
    if not addr.blank?
      addr = addr[1]
    end
    Merchant.find(merchantid).update(address: "#{addr}", phone: "#{phone}")
  end
end
