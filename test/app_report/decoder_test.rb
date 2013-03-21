require 'test_helper'

class DecoderTest < MiniTest::Unit::TestCase

  def test_decode_base64
    expected = 'Boring string...'
    encoded  = Base64.encode64(expected)
    given    = AppReport::Decoder.decode_base64 encoded

    assert_equal expected, given
  end

  def test_decode_blank_encoded_error
    [nil, ''].each { |nil_or_empty|
      test_error_msg = "an error must be raised, when encoded is #{nil_or_empty.nil? ? 'nil' : 'empty'}"

      assert_raises AppReport::Errors::DecoderError, test_error_msg do
        AppReport::Decoder.decode nil_or_empty
      end
    }
  end

  def test_decode_blank_encoding_error
    [nil, ''].each { |nil_or_empty|
      test_error_msg = "an error must be raised, when encoding is #{nil_or_empty.nil? ? 'nil' : 'empty'}"

      assert_raises AppReport::Errors::DecoderError, test_error_msg do
        AppReport::Decoder.decode 'encoded', nil_or_empty
      end
    }
  end

  def test_decode_with_base64_encoding
    expected = "Sexy string!"
    encoded  = Base64.encode64(expected)
    given    = AppReport::Decoder.decode encoded, 'base64'

    assert_equal expected, given
  end

  def test_unsupported_encoding_error
    assert_raises AppReport::Errors::DecoderError do
      AppReport::Decoder.decode 'str', 'unsuported-encoding'
    end
  end

end