AuthorizationModule::Config::AuthorizationConfiguration.configuration do |config|
  attribute_provider_factory = AuthorizationModule::Abac::AttributeProviderFactory.new
  config.identity_repository = AuthorizationModule::Models::Identity
  config.permission_repository = AuthorizationModule::Models::Permission
  config.policy_repository = AuthorizationModule::Models::Policy
  config.role_repository = AuthorizationModule::Models::Role
  config.role_grant_repository = AuthorizationModule::Models::RoleGrant
  config.user_group_repository = AuthorizationModule::Models::UserGroup
  config.attribute_provider_factory = attribute_provider_factory
  config.policy_enforcer = AuthorizationModule::PolicyEnforcer.new(attribute_provider_factory: attribute_provider_factory)
  config.model_inheritance = ::ActiveRecord::Base
end

AuthorizationModule::Config::ErrorConfiguration.configuration do |config|
  config.unauthorized_error_class = AuthorizationModule::Errors::UnauthorizedError
  config.unauthenticated_error_class = AuthorizationModule::Errors::UnauthenticatedError
end
