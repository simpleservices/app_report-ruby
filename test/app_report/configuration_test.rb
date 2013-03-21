require 'test_helper'

class ConfigurationTest < MiniTest::Unit::TestCase

  def setup
    @configuration_class = AppReport::Configuration

    @default_settings = {
      :app_name   => 'app',
      :access_key => '123',
      :secret_key => '123abc'
    }
  end

  def test_response_to_config_keys
    assert_respond_to @configuration_class, :config_keys
  end

  def test_immutability_of_config_keys
    @configuration_class.config_keys.delete :app_name
    assert_includes @configuration_class.config_keys, :app_name
  end

  def test_response_to_each_config_keys
    @configuration_class.config_keys.each do |key|
      assert_respond_to @configuration_class, key
    end
  end

  def test_response_to_validates
    assert_respond_to @configuration_class, :validates!
  end

  def test_validation_of_expires_signed_url_after
    assert_raises AppReport::Errors::InvalidConfigurationError do
      @configuration_class.expires_signed_url_after = nil
    end
  end

  def test_validation_of_required_keys
    @configuration_class.config_keys.each { |key|
      next if key == :expires_signed_url_after

      @default_settings.each do |k, v|
        @configuration_class.send "#{k}=", v
      end

      @configuration_class.send "#{key}=", nil

      test_error_msg = "a RequiredConfigurationError must be raised when #{key} is empty"
      assert_raises AppReport::Errors::RequiredConfigurationError, test_error_msg do
        @configuration_class.validates!
      end
    }
  end

  def test_default_expires_signed_url_after_value
    assert_equal 600, @configuration_class.expires_signed_url_after
  end

end