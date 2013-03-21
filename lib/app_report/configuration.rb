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
  module Configuration

    @@config_keys = [
      :app_name,
      :access_key,
      :secret_key,
      :expires_signed_url_after
    ]

    mattr_accessor *@@config_keys

    # default values

    # expire urls after 10 minutes, by default.
    @@expires_signed_url_after = 600

    def self.expires_signed_url_after= value
      unless value.kind_of? Integer and value > 0
       raise AppReport::Errors::InvalidConfigurationError, "value must be an integer > 0, not #{value}"
      end

      @@expires_signed_url_after = value
    end

    def self.config_keys
      @@config_keys.clone
    end

    def self.validates!
      config_keys.each do |key|
        raise AppReport::Errors::RequiredConfigurationError, "#{key} is required" if send(key).blank?
      end
    end

  end
end