
# fake api used to test the AppReport::API::Base class

module AppReport
  module API
    class FakeAPI < AppReport::API::Base

      def params_to_sign
        [:app_name, :access_key, :document, :id, :inexistent_param]
      end

    end
  end
end