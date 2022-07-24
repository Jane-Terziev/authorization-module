require 'rails'

module AuthorizationModule
  class Railtie < Rails::Railtie
    railtie_name :"authorization_module"

    rake_tasks do
      load "authorization_gem/tasks/authorization_module_tasks.rake"
    end
  end
end