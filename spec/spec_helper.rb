# frozen_string_literal: true

require "authorization_module"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  db_configuration_file = File.join(File.expand_path('..', __FILE__), 'support', 'db', 'config.yml')
  db_config = YAML.load(File.read(db_configuration_file))
  ActiveRecord::Base.establish_connection(db_config["test"])
end
