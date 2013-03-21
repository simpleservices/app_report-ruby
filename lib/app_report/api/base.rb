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
    class Base

      attr_accessor :params

      def initialize
        @params = {}
      end

      def params_to_sign
        []
      end

      def sign_params params
        string = params.map { |k, v| v.to_s }.join
        SimpleSigner.sign :secret_key => AppReport.settings.secret_key, :string => string
      end

      def signed_params
        params = {}

        # include params that must be signed
        params_to_sign.each { |param|
          params[param] = @params[param]#  unless params.include? param
        }

        # include configured keys
        params.merge! :app_name   => AppReport.settings.app_name,
                      :expires    => Time.now.to_i + AppReport.settings.expires_signed_url_after

        # sign params
        params.merge! :signature  => sign_params(params),
                      :access_key => AppReport.settings.access_key

        # include not signed params
        @params.merge params
      end
    end
  end
end