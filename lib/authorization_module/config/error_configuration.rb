require_relative '../errors/unauthorized_error'
require_relative '../errors/unauthenticated_error'

module AuthorizationModule
  module Config
    module ErrorConfiguration
      extend Configuration

      define_setting :unauthorized_error_class, ::AuthorizationModule::Errors::UnauthorizedError
      define_setting :unauthenticated_error_class, ::AuthorizationModule::Errors::UnauthenticatedError
    end
  end
end