module AuthorizationModule
  module Errors
    class MissingConfigError < StandardError
      attr_accessor :message, :error

      def initialize(msg:, error: 'missing_config_error')
        self.message = msg
        self.error = error
      end
    end
  end
end
