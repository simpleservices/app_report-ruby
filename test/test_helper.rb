require 'minitest/autorun'
require 'minitest/colorize'
require 'webmock/minitest'
require 'app_report'

def stub_post(path)
  stub_request(:post, AppReport::Client::endpoint + path)
end

def fixture_path
  File.expand_path '../fixtures', __FILE__
end

def fixture file
  File.new File.join(fixture_path, file)
end