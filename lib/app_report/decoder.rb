=begin
This file is part of AppReport.

AppReport is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, version 3 of the License.

AppReport is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with AppReport.  If not, see <http://www.gnu.org/licenses/>.
=end

module AppReport
  module Decoder

    def self.decode encoded, encoding = 'base64'
      supported = ['base64']

      if encoded.blank?
        raise AppReport::Errors::DecoderError, "Encoded can't be blank"

      elsif encoding.blank?
        raise AppReport::Errors::DecoderError, "Encoding can't be blank!"

      elsif not supported.include? encoding
        raise AppReport::Errors::DecoderError, "Encoding '#{encoding}' not supported, only #{supported}."
      end

      send "decode_#{encoding}", encoded
    end

    def self.decode_base64 encoded
      Base64.decode64 encoded
    end

  end
end