module AuthorizationModule
  class IdentityService
    def initialize(
        identity_repository: AuthorizationModule::Config::AuthorizationConfiguration.identity_repository,
        group_repository: AuthorizationModule::Config::AuthorizationConfiguration.group_repository,
        role_repository: AuthorizationModule::Config::AuthorizationConfiguration.role_repository
    )

      self.identity_repository = identity_repository
      self.group_repository = group_repository
      self.role_repository = role_repository
    end

    def create_identity(command)
      ActiveRecord::Base.transaction do
        identity_repository.create_new(
            id: command.id,
            group_id: group_repository.find_by_name(command.group_name).map(&:id).or_else_raise(&StandardError.method(:new)),
            role: role_repository.find_by_name(command.role_name).or_else_raise(&StandardError.method(:new))
        ).tap{ |identity| identity_repository.save!(identity) }
      end
    end

    private

    attr_accessor :identity_repository, :group_repository, :role_repository
  end
end