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

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/object/try'

require 'simple_signer'
require 'multi_json'
require 'faraday'

require 'base64'

require 'app_report/errors'
require 'app_report/configuration'
require 'app_report/client'
require 'app_report/decoder'
require 'app_report/api/base'
require 'app_report/api/jasper'
require 'app_report/report/jasper'

module AppReport

  def self.configure
    yield AppReport::Configuration

    AppReport::Configuration.validates!
    AppReport::Configuration
  end

  def self.settings
    AppReport::Configuration
  end
end
