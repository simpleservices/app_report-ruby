require 'test_helper'
require 'app_report/api/fake_api'

class BaseAPITest < MiniTest::Unit::TestCase

  def setup

    AppReport.configure do |config|
      config.app_name   = 'app'
      config.access_key = 'L3jC1SHoo3mqWZ2kT7m4'
      config.secret_key = '6zD1sMPAYJdBj/SUMqi/BIqayWkjx3PSV1KaQyND'
    end

    @base_api_class = AppReport::API::Base
    @base_api       = @base_api_class.new


    # using fake api to test custom params

    @fake_api = AppReport::API::FakeAPI.new

    @fake_api.params = {
      :document => '123456789abc',
      :id       => 123
    }
  end

  def test_assignment_of_params
    base_api = @base_api_class.new
    assert_includes base_api.instance_variables, :@params
  end

  def test_params_to_sign_return_an_empty_array
    assert_equal [], @base_api.params_to_sign
  end

  def test_sign_params_return_a_string
    assert_kind_of String, @base_api.sign_params({})
  end

  def test_signed_params_is_a_hash
    assert_kind_of Hash, @base_api.signed_params
  end

  def test_signed_params_include_configured_keys
    signed_params = @base_api.signed_params

    [:app_name, :access_key].each do |key|
      assert_includes signed_params, key
      assert_equal AppReport.settings.send(key), signed_params[key]
    end
  end

  def test_signed_params_include_expires
    signed_params = @base_api.signed_params
    assert_includes signed_params, 'expires'
  end

  def test_configured_keys_not_overwritten_by_params
    @base_api.params[:app_name]   = 'overwritten_app_name'
    @base_api.params[:access_key] = 'overwritten_access_key'

    signed_params = @base_api.signed_params

    [:app_name, :access_key].each do |key|
      assert_equal AppReport.settings.send(key), signed_params[key]
    end
  end

  def test_expires_not_overwritten_by_params
    expires                    = 100
    @base_api.params[:expires] = expires
    signed_params              = @base_api.signed_params

    refute_equal expires, signed_params[:expires]
  end


  def test_signed_params_include_all_params_including_not_signed
    @fake_api.params[:foo] = 'new param value'
    signed_params          = @fake_api.signed_params

    @fake_api.params.each do |key, value|
      assert_includes signed_params, key
    end
  end

  def test_signed_params_include_expires
    assert_includes @base_api.signed_params, :expires
  end

  def test_signed_params_expires
    expected   = Time.now.to_i + AppReport.settings.expires_signed_url_after
    calculated = @base_api.signed_params[:expires]

    assert_equal expected, calculated
  end

  def test_signed_params_include_signature
    assert_includes @base_api.signed_params, :signature
  end

  def test_sign_params_signature
    params = {
      :foo => 'bar',
      :hey => "what's up?"
    }

    params_string = params.map { |k, v| v.to_s }.join

    expected_signature = SimpleSigner.sign \
      :secret_key => AppReport.settings.secret_key,
      :string     => params_string

    given_signature = @base_api.sign_params params

    assert_equal expected_signature, given_signature
  end

  def test_signed_params_signature

    # expected

    params = {}

    @fake_api.params_to_sign.each { |param|
      params[param] = @fake_api.params[param]
    }

    params.merge! :app_name   => AppReport.settings.app_name,
                  :expires    => Time.now.to_i + AppReport.settings.expires_signed_url_after

    params_string = params.map { |k, v| v.to_s }.join


    expected_signature = SimpleSigner.sign \
      :secret_key => AppReport.settings.secret_key,
      :string     => params_string


    # given

    given_signature = @fake_api.signed_params[:signature]

    assert_equal expected_signature, given_signature
  end
end