module AuthorizationModule
  module Errors
    class UnauthenticatedError < ApiError
      def initialize(msg = "Invalid Credentials", code = 401, error = 'unauthenticated_error')
        super(msg, code, error)
      end
    end
  end
end
