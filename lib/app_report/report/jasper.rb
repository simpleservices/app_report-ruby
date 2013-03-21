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
  module Report

    class Jasper

      def initialize attributes = {}
        attributes = {
          :template_name    => nil,
          :data_type        => 'empty',
          :data             => '',
          :xpath_expression => '',
          :args             => {}
        }.merge attributes

        @attributes = attributes
      end

      # attributes

      def attributes
        @attributes.clone
      end

      def template_name
        @attributes[:template_name]
      end

      def data_type
        @attributes[:data_type]
      end

      def data
        @attributes[:data]
      end

      def xpath_expression
        @attributes[:xpath_expression]
      end

      def args
        @attributes[:args]
      end


      # validations

      def validates_all_attributes!
        @attributes.each do |key, value|
          send "validates_#{key}!"
        end
      end
      alias validates! validates_all_attributes!

      def validates_presence_of! option_name
        raise AppReport::Errors::ValidationError, "#{option_name} is required" if send(option_name).blank?
      end

      def validates_template_name!
        validates_presence_of! :template_name
      end

      def validates_data_type!
      end

      def validates_data!
      end

      def validates_xpath_expression!
      end

      def validates_args!
      end

    end

  end
end