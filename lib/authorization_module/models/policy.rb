require_relative '../config/authorization_configuration'

module AuthorizationModule
  module Models
    class Policy < ::AuthorizationModule::Config::AuthorizationConfiguration.model_inheritance
      self.table_name = :authorization_policies

      ALLOW = 0
      DENY  = 1

      ANY_RESOURCE_TYPE = '*'
      ANY_ACTION        = '*'

      def self.create_new(id: SecureRandom.uuid, name:, description:, resource_type:, action:, effect:)
        new(
            id: id,
            name: name,
            description: description,
            resource_type: resource_type,
            action: action,
            effect: effect,
            created_at: DateTime.now,
            updated_at: DateTime.now
        )
      end

      def allows?(action, resource_type)
        matches_resource_type?(resource_type.to_s) && matches_action?(action) && allow?
      end

      def denies?(action, resource_type)
        matches_resource_type?(resource_type.to_s) && matches_action?(action) && deny?
      end

      private

      def matches_resource_type?(resource_type)
        return false unless resource_type.deconstantize == self.resource_type.deconstantize

        resource_name = self.resource_type.demodulize
        resource_name == ANY_RESOURCE_TYPE || resource_name == resource_type.demodulize
      end

      def matches_action?(action)
        self.action == ANY_ACTION || self.action == action
      end

      def allow?
        effect == ALLOW
      end

      def deny?
        effect == DENY
      end
    end
  end
end
