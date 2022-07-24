AuthorizationModule::Config::AuthorizationConfiguration.configuration do |config|
  attribute_provider_factory = AuthorizationModule::Abac::AttributeProviderFactory.new
  config.identity_repository = AuthorizationModule::Models
  config.permission_repository = AuthorizationModule::Models
  config.policy_repository = AuthorizationModule::Models
  config.role_repository = AuthorizationModule::Models
  config.role_grant_repository = AuthorizationModule::Models
  config.user_group_repository = AuthorizationModule::Models
  config.current_user_repository =
      config.attribute_provider_factory = attribute_provider_factory
  config.policy_enforcer = AuthorizationModule::PolicyEnforcer.new(attribute_provider_factory: attribute_provider_factory)
  config.model_inheritance = ::ActiveRecord::Base
end

AuthorizationModule::Config::ErrorConfiguration.configuration do |config|
  config.unauthorized_error_class = AuthorizationModule::Errors::Unauthorized
  config.unauthenticated_error_class = AuthorizationModule::Errors::Unauthenticated
end