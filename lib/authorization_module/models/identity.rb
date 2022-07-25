require_relative '../config/authorization_configuration'
require_relative 'user_group'

module AuthorizationModule
  module Models
    class Identity < ::AuthorizationModule::Config::AuthorizationConfiguration.model_inheritance
      self.table_name = :authorization_identities

      belongs_to :user_group,
                 class_name: '::AuthorizationModule::Models::UserGroup',
                 foreign_key: 'group_id',
                 optional: true

      has_many :role_grants,
              class_name: '::AuthorizationModule::Models::RoleGrant',
              autosave: true

      attr_accessor :access_token

      def self.create_new(id: SecureRandom.uuid, group_id:, role: nil)
        identity = new(
            id: id,
            group_id: group_id
        )

        identity.assign_role(role)
        identity
      end

      def assign_role(role)
        return unless role
        return if has_role?(role.name)

        role_grants.build(identity: self, role: role)
      end

      def set_role(role)
        role_grants.destroy_all
        assign_role(role)
      end

      def has_role?(role_name)
        role_grants.any? { |it| it.role.name == role_name }
      end

      def roles
        role_grants.map(&:role)
      end

      def role_name
        role_name = roles.min { |a, b| a.hierarchy <=> b.hierarchy }
        role_name ? role_name.name : ""
      end

      def permissions
        user_group.permissions + roles.map(&:permissions).flatten
      end

      def hierarchical_permissions
        [user_group.permissions].concat(
            roles.sort { |a, b| a.hierarchy <=> b.hierarchy }.map(&:permissions)
        ).reject(&:empty?)
      end
    end
  end
end
