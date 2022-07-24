module AuthorizationModule
  class AuthorizationService
    def initialize(
        policy_enforcer: Config::AuthorizationConfiguration.policy_enforcer,
        unauthorized_error_class: Config::AuthorizationConfiguration.unauthorized_error_class,
        unauthenticated_error_class: Config::AuthorizationConfiguration.unauthenticated_error_class,
        current_user_repository: Config::AuthorizationConfiguration.current_user_repository
    )
      self.policy_enforcer = policy_enforcer
      self.unauthorized_error_class = unauthorized_error_class
      self.unauthenticated_error_class = unauthenticated_error_class
      self.current_user_repository = current_user_repository
    end

    def authorize_action(action, resource_type, context = {})
      current_user = current_user_repository.current_user
      raise self.unauthenticated_error_class unless current_user
      authorized = self.policy_enforcer.action_allowed?(
          action,
          resource_type,
          current_user,
          context
      )

      raise self.unauthorized_error_class unless authorized
    end

    def authorize_action_on_resource(action, resource_type, resource_id, context = {})
      current_user = current_user_repository.current_user
      raise self.unauthenticated_error_class unless current_user

      authorized = policy_enforcer.action_allowed_on_resource?(
          action,
          resource_type,
          current_user,
          resource_id,
          context
      )

      raise self.unauthorized_error_class unless authorized
    end

    private

    attr_accessor :policy_enforcer, :unauthorized_error_class, :unauthenticated_error_class, :current_user_repository
  end
end
