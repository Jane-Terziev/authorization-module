# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'standalone_migrations'

ENV["SCHEMA"] = File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, "schema.rb")
StandaloneMigrations::Tasks.load_tasks
RSpec::Core::RakeTask.new(:spec)

task default: :spec
