require 'test_helper'
require 'tempfile'

class JasperAPITest < MiniTest::Unit::TestCase

  def setup

    AppReport.configure do |config|
      config.app_name   = 'app-name'
      config.access_key = 'access-key'
      config.secret_key = 'secret-key'
    end

    @default_report_options = {
      :template_name    => 'some_report',
      :data_type        => 'xml',
      :data             => '<?xml version="1.0" encoding="utf-8"?><root><node></node></root>',
      :xpath_expression => '/root/node',
      :args             => { :key => 'value' }
    }

    @api       = AppReport::API::Jasper.new
    @report    = AppReport::Report::Jasper.new @default_report_options
  end

  def test_params_to_sign
    params_to_sign = @api.params_to_sign

    [:app_name, :template_name, :expires].each do |key|
      assert_includes params_to_sign, key
    end
  end

  # validation of report argument
  def test_validation_of_report_arg
    [:validates_report!, :build!].each do |method|
      test_error_msg = "a validation error must be raised by #{method}"

      assert_raises AppReport::Errors::ValidationError, test_error_msg do
        @api.send method, nil
      end
    end
  end

  # report validation, build! must call the validates! method of the report.
  def test_report_validation
    report         = AppReport::Report::Jasper.new
    test_error_msg = 'a validation error must be raised by report in build'

    assert_raises AppReport::Errors::ValidationError, test_error_msg do
      @api.build! report
    end
  end

  def test_decode_blank_report_error
    [nil, ''].each { |nil_or_empty|
      response_body  = MultiJson.dump({ 'report' => nil_or_empty })
      test_error_msg = "an error must be raised, when report is #{nil_or_empty.nil? ? 'nil' : 'empty'}"

      assert_raises AppReport::Errors::APIResponseError, test_error_msg do
        @api.decode_report! response_body
      end
    }
  end

  def test_decode_report
    expected = 'hello, am I a report?'

    response_body = MultiJson.dump({
      'report' => {
        'encoding' => 'base64',
        'encoded'  => Base64.encode64(expected)
      }
    })

    given = @api.decode_report! response_body

    assert_equal expected, given
  end

  def test_build_set_report_attributes_as_params
    stub_post('/api/v1/factory/jasper/build.json').to_return \
      :body    => fixture('report.json'),
      :headers => { :content_type => "application/json; charset=utf-8" }

    @api.build! @report

    @report.attributes.each do |key, value|
      assert_includes @api.params, key
      assert_equal @api.params[key], @report.attributes[key]
    end
  end


  def test_build
    stub_post('/api/v1/factory/jasper/build.json').to_return \
      :body    => fixture('report.json'),
      :headers => { :content_type => "application/json; charset=utf-8" }

    expected_pdf_raw = fixture('report.pdf').read
    given_pdf_raw    = @api.build! @report


    # writting a file, because
    # assert_equal(expected_pdf_raw, given_pdf_raw) fails
    #
    # probably it's not the best solution, but for now it works!

    f = Tempfile.new 'given.pdf'

    begin
      f.write given_pdf_raw
      f.rewind

      assert_equal expected_pdf_raw, f.read
    ensure
      f.close
    end
  end

end
