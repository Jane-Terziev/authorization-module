# frozen_string_literal: true

require "authorization_module/version"
require 'authorization_module/config/configuration'
require 'authorization_module/config/authorization_configuration'
require 'authorization_module/config/error_configuration'
require "authorization_module/abac/attribute_provider_factory"
require "authorization_module/abac/condition_serializer"
require "authorization_module/abac/null_attribute_provider"
require 'authorization_module/errors/unauthorized_error'
require 'authorization_module/errors/unauthenticated_error'
require 'authorization_module/errors/missing_config_error'
require 'authorization_module/errors/api_error'
require 'authorization_module/models/identity'
require 'authorization_module/models/permission'
require 'authorization_module/models/policy'
require 'authorization_module/models/role'
require 'authorization_module/models/role_grant'
require 'authorization_module/models/abac/condition'
require 'authorization_module/railtie' if defined?(Rails)
require 'authorization_module/policy_enforcer'
require 'authorization_module/authorization_service'

module AuthorizationModule
end