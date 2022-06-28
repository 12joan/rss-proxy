module Transformer
  def self.transform(document)
    document.xpath('//rss/channel/item').each do |item|
      item.at('title').content = item.at('title').content.reverse
    end
  end
end
