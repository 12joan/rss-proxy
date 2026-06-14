ENV['APP_ENV'] = 'test'
ENV['TOKEN'] = 'test-token'
ENV['TRANSFORMER_PATH'] = 'test/test_transformer.rb'

require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'
require 'app/application'

class Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def self.fixture it:, upstream:, expected:
    self.it it do
      expected = File.read(expected)
      get "/#{ENV.fetch('TOKEN')}/#{upstream}"
      assert_predicate last_response, :ok?
      assert_equal expected, last_response.body.encode('UTF-8')
    end
  end
end
