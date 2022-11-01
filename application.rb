require 'sinatra'
require '/transformer'
require 'active_support/security_utils'
require 'open-uri'
require 'nokogiri'

get '/healthcheck' do
  'OK'
end

get '/*' do
  _, token, *path_parts = request.fullpath.split('/')
  upstream = path_parts.join('/')

  if ActiveSupport::SecurityUtils.secure_compare(token, ENV.fetch('TOKEN'))
    transformer = Transformer.new
    uri = transformer.transform_uri(URI.parse('https://' + upstream))
    original_document = Nokogiri::XML(URI.open(uri))
    transformed_document = transformer.transform_document(original_document)
    transformed_document.to_xml
  else
    'Invalid token'
  end
end
