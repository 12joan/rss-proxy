require_relative './test_setup'

describe 'healthcheck' do
  it 'responds with OK' do
    get '/healthcheck'
    assert_predicate last_response, :ok?
    assert_equal 'OK', last_response.body
  end
end
