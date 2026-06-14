require 'open-uri'

class BaseTransformer
  # Delegate to a sub-transformer based on the upstream path (everything after
  # '/:token/'). This should return an instance of BaseTransformer.
  def match upstream
    self
  end

  # Transform the upstream URI object
  def transform_uri uri
    uri
  end

  # Fetch the content of the upstream URI (mainly overridden for testing)
  def fetch uri
    URI.open(uri)
  end

  # Mutate the Nokogiri document before it's returned
  def transform_document document
  end
end
