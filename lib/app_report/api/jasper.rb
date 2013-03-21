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
  module API
    class Jasper < AppReport::API::Base

      def params_to_sign
       [:app_name, :template_name, :expires]
      end

      def build! report

        @report = report
        validates_report! @report
        @report.validates!

        @params = @report.attributes

        path     = '/api/v1/factory/jasper/build.json'
        response = AppReport::Client.post path, signed_params

        decode_report! response.body
      end

      def decode_report! response_body
        response_body = MultiJson.load response_body
        report        = response_body['report']

        if report.blank?
          raise AppReport::Errors::APIResponseError, "API returned a blank report!"
        end

        AppReport::Decoder.decode report['encoded'], report['encoding']
      end

      # validations

      def validates_report! report
        unless report.kind_of? AppReport::Report::Jasper
          error_msg = "report must be a instance of AppReport::Report::Jasper not #{report.class.name}"
          raise AppReport::Errors::ValidationError, error_msg
        end
      end

    end
  end
end