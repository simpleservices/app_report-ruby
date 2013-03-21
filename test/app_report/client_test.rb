require 'test_helper'

class ClientTest < MiniTest::Unit::TestCase

  def test_default_endpoint
    assert_equal \
      'http://reports.simpleservic.es', 
      AppReport::Client.endpoint
  end

  def test_connection_return_faraday_connection
    assert_kind_of Faraday::Connection, AppReport::Client.connection 
  end

  def test_post_return_faraday_response
    path = '/faraday_response.json'

    stub_post(path).to_return \
      :body    => {}, 
      :headers => { :content_type => "application/json; charset=utf-8" }

    assert_kind_of Faraday::Response, AppReport::Client.post(path, {})
  end

  def test_raise_error_messages
    assert_raises AppReport::Errors::APIError do
      AppReport::Client.raise_error_messages! fixture('error_messages.json')
    end
  end

  def test_post_raise_error_messages
    path = '/error_messages.json'

    stub_post(path).to_return \
      :body    => fixture('error_messages.json'), 
      :headers => { :content_type => "application/json; charset=utf-8" }

    assert_raises AppReport::Errors::APIError do
      AppReport::Client.post(path, {})
    end
  end

end