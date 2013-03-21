require 'test_helper'

class AppReportTest < MiniTest::Unit::TestCase

  def setup
    AppReport.configure do |config|
      config.app_name   = 'app'
      config.access_key = '123'
      config.secret_key = '123abc'
    end
  end

  def test_response_to_configure
    assert_respond_to AppReport, :configure
  end

  def test_configure_block_yields_configuration
    AppReport.configure do |config|
      assert_equal AppReport::Configuration, config
    end
  end

  def test_response_to_settings
    assert_respond_to AppReport, :settings
  end

  def test_settings_return_configuration
    assert_equal AppReport::Configuration, AppReport::settings
  end

  def test_configure_block_change_settings
    AppReport.configure do |config|
      config.app_name = 'app_name1'
    end

    assert_equal 'app_name1', AppReport.settings.app_name
  end

  def test_settings_changed_via_atributes
    AppReport.settings.app_name = 'app_name2'

    AppReport.configure do |config|
      assert_equal 'app_name2', config.app_name
    end
  end

  def test_settings_validation
    assert_raises AppReport::Errors::RequiredConfigurationError do
      AppReport.configure do |config|
        config.app_name = nil
      end
    end
  end
end
