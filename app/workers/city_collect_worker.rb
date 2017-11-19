class CityCollectWorker
  include Sidekiq::Worker
  # 城市信息采集Worker
  def perform()
    response = RestClient.get "https://i.meituan.com/index/changecity"
    rbody = response.body
    # 得到城市名数组
    cityname = rbody.scan(/data-citypinyin="[a-z]*">(\S*)</)
    # 将数组转为字符串
    cityname = cityname.join(":")
    cityname = cityname.split(":")
    # 得到城市拼音数组
    citypinyin = rbody.scan(/data-citypinyin="(\S*)">/)
    # 将数组转为字符串
    citypinyin = citypinyin.join(":")
    citypinyin = citypinyin.split(":")
    # citypinyin 从0开始取
    index = 0
    # 循环取得城市名
    cityname.each do |c|
      # 根据得到的城市拼音发送get请求，获得ci城市ID
      ciresponse = RestClient.get "http://i.meituan.com/?city=#{citypinyin[index]}"
      # 从cookie中取得ci城市ID
      ci = ciresponse.cookies["ci"]
      City.create(name: c, citypinyin: citypinyin[index], ci: ci)
      index = index + 1
    end
  end
end
