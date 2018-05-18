class BaiduDict
  # author vietlami
  require 'rest-client'
  require 'nokogiri'
  require 'mechanize'
  def self.get_request(keyword)
    # 词语
    keyword = "荣誉"
    url = "https://hanyu.baidu.com/s?wd=#{CGI.escape(keyword)}&from=zici#basicmean"
    page = Nokogiri::HTML(Mechanize.new.get(url).body)
    content = {}
    # 拼音
    content["pinyin".to_sym] = page.search("dt[@class='pinyin']").inner_text

    # 基本解释
    content["basicmean".to_sym] = []
    page.search("div[@id='basicmean-wrapper']").search("p").each do |item|
      content["basicmean".to_sym] << item.inner_text
    end

    # 详细解释
    content["basicmean".to_sym] = []
    page.search("div[@id='detailmean-wrapper']").search("li").each do |item|
      item_arr = []
      item_arr << item.search("p")[0].inner_text
      item_arr << item.search("p")[1].inner_text
      content["basicmean".to_sym] << item_arr
    end

    # 近义词
    content["synonym".to_sym] = []
    page.search("div[@id='synonym']").search("a").each do |item|
      content["synonym".to_sym] << item.inner_text
    end
    # 反义词
    content["antonym".to_sym] = []
    page.search("div[@id='antonym']").search("a").each do |item|
      content["antonym".to_sym] << item.inner_text
    end
    # 翻译
    content["fanyi".to_sym] = page.search("div[@id='fanyi-wrapper']").search("dt").inner_text
  end

end