require_relative 'configuration'
require_relative '../policy_enforcer'
require_relative '../abac/attribute_provider_factory'
require 'active_record'

module AuthorizationModule
  module Config
    module AuthorizationConfiguration
      extend Configuration

      define_setting :identity_repository
      define_setting :permission_repository
      define_setting :policy_repository
      define_setting :role_repository
      define_setting :role_grant_repository
      define_setting :user_group_repository
      define_setting :attribute_provider_factory, ::AuthorizationModule::Abac::AttributeProviderFactory.new
      define_setting :policy_enforcer, ::AuthorizationModule::PolicyEnforcer.new(attribute_provider_factory: attribute_provider_factory)
      define_setting :model_inheritance, ::ActiveRecord::Base
    end
  end
end