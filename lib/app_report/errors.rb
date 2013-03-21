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
  module Errors
    class AppReportError < StandardError
    end


    # validation

    class ValidationError < AppReportError
    end


    # configuration

    class ConfigurationError < AppReportError
    end

    class RequiredConfigurationError < ConfigurationError
    end

    class InvalidConfigurationError < ConfigurationError
    end


    # API

    class APIError < AppReportError
    end

    class APIResponseError < APIError
    end


    # decoder

    class DecoderError < AppReportError
    end

  end
end
