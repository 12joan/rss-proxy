require_relative './test_setup'

describe 'transformer' do
  fixture(
    it: 'returns a sample RSS file',
    upstream: 'sample',
    expected: 'test/fixtures/sample.expected.rss'
  )

  fixture(
    it: 'transforms the URI',
    upstream: 'transform-my-uri',
    expected: 'test/fixtures/sample.expected.rss'
  )

  fixture(
    it: 'transforms the RSS file',
    upstream: 'reverse-titles',
    expected: 'test/fixtures/reversed_titles.expected.rss'
  )
end
