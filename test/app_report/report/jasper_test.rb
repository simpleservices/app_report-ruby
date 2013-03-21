require 'test_helper'

class JasperReportTest < MiniTest::Unit::TestCase

  def setup

    @default_attributes = {
      :template_name    => 'my_super_template',
      :data_type        => 'xml',
      :data             => '<?xml version="1.0" encoding="utf-8"?><root><node></node></root>',
      :xpath_expression => '/root/node',
      :args             => { :key => 'value' }
    }

    @report_class    = AppReport::Report::Jasper
    @report          = @report_class.new @default_attributes
  end


  # attributes

  def test_assignment_of_attributes
    report = @report_class.new
    assert_includes report.instance_variables, :@attributes
  end

  def test_response_to_attributes
    assert_respond_to @report, :attributes
  end

  def test_immutability_of_attributes_hash
    @report.attributes[:template_name] = 'it_was_overwritten!'
    refute_equal @report.template_name, 'it_was_overwritten!'
  end

  def test_response_to_each_option
    @report.attributes.each do |key, value|
      assert_respond_to @report, key, "report must respond to #{key}"
    end
  end

  def test_return_of_each_option
    @report.attributes.each do |key, value|
      assert_equal value, @report.send(key), "#{key} must return the value sent for #{key} option"
    end
  end


  # validations

  def test_response_to_validates_each_option
    @report.attributes.each do |key, value|
      method = "validates_#{key}!"
      assert_respond_to @report, method, "report must respond to #{method}"
    end
  end

  def test_response_to_validates_all_attributes
    assert_respond_to @report, :validates_all_attributes!
  end

  def test_response_to_alias_of_validates_all_attributes
    assert_respond_to @report, :validates!
  end

  def test_response_to_validates_presence_of
    assert_respond_to @report, :validates_presence_of!
  end

  def test_validation_of_template_name
    report = @report_class.new @default_attributes.except :template_name

    [:validates_template_name!, :validates_all_attributes!, :validates! ].each do |method|
      test_error_msg = "a validation error must be raised by #{method}"

      assert_raises AppReport::Errors::ValidationError, test_error_msg do
        report.send method
      end
    end
  end

  # TODO test validation of other attributes in client side.
end
