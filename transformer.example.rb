class Transformer
  # Rewrite https://twitter/:id to https://nitter.ca/:id/rss
  def transform_uri(original_uri)
    original_uri.clone.tap do |uri|
      case original_uri.host
      when 'twitter'
        uri.host = 'nitter.ca'
        uri.path = "#{original_uri.path}/rss"
      end
    end
  end

  # Reverse the title
  def transform_document(document)
    document.xpath('//rss/channel/item').each do |item|
      item.at('title').content = item.at('title').content.reverse
    end
  end
end
