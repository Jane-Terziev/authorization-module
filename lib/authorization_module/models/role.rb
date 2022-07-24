require_relative '../config/authorization_configuration'

module AuthorizationModule
  module Models
    class Role < ::AuthorizationModule::Config::AuthorizationConfiguration.model_inheritance
      self.table_name = :authorization_roles

      has_many :permissions,
               class_name: '::AuthorizationModule::Models::Permission',
               as: :owner,
               autosave: true

      def self.create_new(id: SecureRandom.uuid, name:, description: '')
        new(id: id, name: name, description: description, created_at: DateTime.now, updated_at: DateTime.now)
      end

      def add_permission(policy)
        association(:permissions).add_to_target(
            ::AuthorizationModule::Models::Permission.create_new(owner: self, policy: policy)
        )
      end
    end
  end
end
