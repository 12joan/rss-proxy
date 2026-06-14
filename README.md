# RSS Proxy

A simple proxy server for RSS feeds that can apply custom transformations to the feed URL and content.

## Usage

Use with Docker Compose:

```yaml
services:
  web:
    # Recommended: Replace main with a specific SHA version from GHCR
    image: ghcr.io/12joan/rss-proxy:main
    ports:
      - '3000:3000'
    environment:
      TOKEN: my-token # Replace with any random string
    volumes:
      - ./transformer.rb:/transformer.rb:ro
```

Start the server with `docker compose up -d` (or the equivalent for your Docker setup). See Docker's [usage instructions](https://docs.docker.com/compose/gettingstarted#step-2-define-and-start-your-services) for more information.

### Request structure

The `TOKEN` environment variable must be included in all requests to the proxy server. Set it to some random value, or some arbitrary value such as `rss` if you don't require authentication.

GET requests sent to the proxy server should have the form `/:token/:upstream`, where `:token` is the value of `TOKEN` and `:upstream` is the URL of some RSS feed accessible to the Docker container. This upstream URL must use HTTPS, but `https://` should be omitted from `:upstream`.

For example, to proxy `https://example.com/my-feed`, send a GET request to `http://localhost:3000/my-token/example.com/my-feed`.

### Transformer file (required)

In the same directory as your Docker Compose file, create a file called `transformer.rb`, copying the initial content from [transformer.example.rb](./transformer.example.rb).

Modify this Ruby file to customise how the proxy server fetches and transforms RSS feeds.

#### XML transformations

You can transform the XML document by overriding the `transform_document` method of the transformer. 

It takes a Nokogiri document, which should be mutated as required. The return value of this method is unused.

```rb
class Transformer < BaseTransformer
  def transform_document document
    document.xpath('//rss/channel/item').each do |item|
      if item.at('title')
        item.at('title').content = item.at('title').content.reverse
      end
    end
  end
end
```

See [Nokogiri's documentation](https://nokogiri.org/) for more information.

#### URI transformations

In case you want to add some indirection to how RSS feeds are requested, you can modify the upstream URI before the proxy server fetches it by overriding `transform_uri`.

This method takes and should return a Ruby `URI` object. You can either return the same `URI` object that was passed to the method or construct a new one.

```rb
class Transformer < BaseTransformer
  def transform_uri uri
    uri.tap do
      case uri.host
      when 'example.com'
        uri.host = 'another-site.com'
      end
    end
  end
end
```

#### Delegate to a sub-transformer

You can perform multiple different kinds of transform depending on the upstream RSS feed URL by conditionally delegating to a sub-transformer using the `match` method.

The `match` method takes the `:upstream` component of the request path (as a string, and still without `https://`) and must return an instance of some transformer class. This can either be the current instance or an instance of some arbitrary subclass.

This subclass can override any method that can be overridden on the parent class, with the exception of `match`. Multi-level `match`ing is not supported.

```rb
class Transformer < BaseTransformer
  def match upstream
    if upsteram.start_with?('example.com')
      ExampleTransformer.new
    else
      self
    end
  end
  
  class ExampleTransformer < self
    # ...
  end
end
```

## Development

For local development, it's simplest to use Docker Compose. First, copy `transformer.example.rb` to `transformer.rb`. You can then start the server using `docker compose up --build`.

Running the server outside of Docker is also possible, although you will need to:

- Set the `TRANSFORMER_PATH` environment variable to the absolute path of the `transformer.rb` file
- Adjust the path used by `transformer.rb` to require `app/base_transformer.rb`

## Testing

Running the unit tests does not require Docker Compose.

```bash
$ bundle install
$ rake test
```

