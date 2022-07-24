require_relative '../config/authorization_configuration'
require_relative '../abac/condition_serializer'

module AuthorizationModule
  module Models
    class Permission < ::AuthorizationModule::Config::AuthorizationConfiguration.model_inheritance
      self.table_name = :authorization_permissions

      belongs_to :owner,  polymorphic: true, optional: true
      belongs_to :policy, class_name: '::AuthorizationModule::Models::Policy', optional: true

      serialize :conditions, ::AuthorizationModule::Abac::ConditionSerializer

      default_scope { includes(:policy) }

      def self.create_new(id: SecureRandom.uuid, owner:, policy:)
        new(
            id: id,
            owner: owner,
            policy: policy
        )
      end

      def allows?(action, resource_type)
        policy.allows?(action, resource_type)
      end

      def allows_on_resource?(action, resource_type, subject, resource, context = {})
        allows?(action, resource_type) && conditions.all? { |condition| condition.satisfied_by?(subject, resource, context) }
      end

      def denies?(action, resource_type)
        policy.denies?(action, resource_type)
      end

      def denies_on_resource?(action, resource_type, subject, resource, context = {})
        denies?(action, resource_type) && conditions.all? { |condition| condition.satisfied_by?(subject, resource, context) }
      end
    end
  end
end
