require_relative '../app/base_transformer'

class Transformer < BaseTransformer
  def match upstream
    case upstream
    when 'sample'
      SampleTransformer.new
    when 'transform-my-uri'
      TransformURITransformer.new
    when 'reverse-titles'
      ReverseTitlesTransformer.new
    else
      raise "Unexpected upstream: #{upstream}"
    end
  end

  class SampleTransformer < self
    def fetch uri
      raise "Wrong URI: #{uri.inspect}" unless uri.to_s == 'https://sample'
      File.read 'test/fixtures/sample.input.rss'
    end
  end

  class TransformURITransformer < SampleTransformer
    def transform_uri uri
      raise "Wrong URI: #{uri.inspect}" unless uri.to_s == 'https://transform-my-uri'

      uri.tap do
        uri.host = 'sample'
      end
    end
  end

  class ReverseTitlesTransformer < self
    def fetch uri
      raise "Wrong URI: #{uri.inspect}" unless uri.to_s == 'https://reverse-titles'
      File.read 'test/fixtures/sample.input.rss'
    end

    def transform_document document
      document.xpath('//rss/channel/item').each do |item|
        item.at('title').content = item.at('title').content.reverse
      end
    end
  end
end
