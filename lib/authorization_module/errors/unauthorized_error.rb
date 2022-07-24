require_relative 'api_error'

module AuthorizationModule
  module Errors
    class UnauthorizedError < ApiError
      def initialize(msg = "Permission denied", code = 403, error = 'unauthorized_error')
        super(msg, code, error)
      end
    end
  end
end
