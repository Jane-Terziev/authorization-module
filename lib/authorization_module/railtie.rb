require 'rails'

module AuthorizationModule
  class Railtie < Rails::Railtie
    railtie_name :"authorization_module"

    rake_tasks do
      load "authorization_module/tasks/authorization_module.rake"
    end
  end
end