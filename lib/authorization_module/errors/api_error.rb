module AuthorizationModule
  module Errors
    class ApiError < StandardError
      attr_accessor :message, :code, :error

      def initialize(msg = "Unauthorized", code = 401, error = 'unauthorized_error')
        self.message = msg
        self.code = code
        self.error = error
      end
    end
  end
end
