require_relative 'config/authorization_configuration'

module AuthorizationModule
  class PolicyEnforcer
    attr_accessor :attribute_provider_factory

    def initialize(attribute_provider_factory: Config::AuthorizationConfiguration.attribute_provider_factory)
      self.attribute_provider_factory = attribute_provider_factory
    end


    def action_allowed?(action, resource_type, user, context = {})
      subject  = self.attribute_provider_factory.subject_provider_for_type(resource_type).attributes_by_id(user.id)
      permissions = user.access_token.present? ? user.access_token.permissions : user.permissions
      if not_using_hierarchical_permissions?(user.access_token)
        decide(
            action,
            resource_type,
            subject,
            OpenStruct.new,
            context,
            permissions
        )
      else
        decide_hierarchical(
            action,
            resource_type,
            subject,
            OpenStruct.new,
            context,
            get_user_permissions(user)
        )
      end
    end

    def action_allowed_on_resource?(action, resource_type, user, resource_id, context = {})
      subject  = self.attribute_provider_factory.subject_provider_for_type(resource_type).attributes_by_id(user.id)
      resource = self.attribute_provider_factory.resource_provider_for_type(resource_type).attributes_by_id(resource_id)
      permissions = user.access_token.present? ? user.access_token.permissions : user.permissions
      if not_using_hierarchical_permissions?(user.access_token)
        decide(
            action,
            resource_type,
            subject,
            resource,
            context,
            permissions
        )
      else
        decide_hierarchical(
            action,
            resource_type,
            subject,
            resource,
            context,
            get_user_permissions(user)
        )
      end
    end

    def get_user_permissions(user)
      user.access_token.present? ? user.access_token.permissions : user.hierarchical_permissions
    end

    def not_using_hierarchical_permissions?(access_token)
      access_token.present? ? !access_token.hierarchical : false
    end

    def decide(action, resource_type, subject, resource, context, permissions)
      allowed = nil
      permissions.each do |permission|
        return false if permission.denies_on_resource?(action, resource_type, subject, resource, context)
        allowed = true if permission.allows_on_resource?(action, resource_type, subject, resource, context)
      end

      allowed
    end

    def decide_hierarchical(action, resource_type, subject, resource, context, permissions)
      permissions.each do |permission_group|
        allowed = decide(action, resource_type, subject, resource, context, permission_group)
        next if allowed.nil?

        return allowed
      end

      false
    end
  end
end
