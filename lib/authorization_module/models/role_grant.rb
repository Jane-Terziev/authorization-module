require_relative '../config/authorization_configuration'

module AuthorizationModule
  module Models
    class RoleGrant < ::AuthorizationModule::Config::AuthorizationConfiguration.model_inheritance
      self.table_name = :authorization_role_grants
      self.primary_key = :id

      belongs_to :identity,
                 class_name: '::AuthorizationModule::Models::Identity',
                 optional: true

      belongs_to :role,
                 class_name: '::AuthorizationModule::Models::Role',
                 optional: true
    end
  end
end
