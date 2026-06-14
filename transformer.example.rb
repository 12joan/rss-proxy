require_relative 'app/app/base_transformer'

class Transformer < BaseTransformer
  # Reverse the title
  def transform_document document
    document.xpath('//rss/channel/item').each do |item|
      if item.at('title')
        item.at('title').content = item.at('title').content.reverse
      end
    end
  end
end
