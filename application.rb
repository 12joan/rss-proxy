require 'sinatra'
require '/transformer'
require 'active_support/security_utils'
require 'open-uri'
require 'nokogiri'

get '/healthcheck' do
  'OK'
end

get %r{/([0-9a-z]+)/(.+)} do |token, upstream|
  if ActiveSupport::SecurityUtils.secure_compare(token, ENV.fetch('TOKEN'))
    Nokogiri::XML(URI.open('https://' + upstream))
      .tap { |document| Transformer.transform(document) }
      .to_xml
  else
    'Invalid token'
  end
end
