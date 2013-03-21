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
  module Client

    @@connection = nil
    @@endpoint   = 'http://reports.simpleservic.es'

    mattr_accessor :endpoint

    def self.post path, params = {}
      response = connection.post do |request|
        request.url path

        request.headers['Content-Type'] = 'application/json'
        request.body                    = MultiJson.dump params
      end

      raise_error_messages! response.body

      response
    end

    def self.connection
      if @@connection.nil?
        @@connection = Faraday.new(:url => @@endpoint) { |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter # same as :net_http
        }
      end

      @@connection
    end

    def self.raise_error_messages! response_body
      response_body = MultiJson.load response_body

      if response_body.try(:[], 'messages').try(:[], 'has_any_error')
        error_messages = response_body['messages']['messages'].map { |m|
          m['message']
        }

        raise AppReport::Errors::APIError, \
          "AppReport API error: #{error_messages}"
      end
    end

  end
end