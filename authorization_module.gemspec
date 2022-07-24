# frozen_string_literal: true

require_relative "lib/authorization_module/version"

Gem::Specification.new do |spec|
  spec.name          = "authorization_module"
  spec.version       = AuthorizationModule::VERSION
  spec.authors       = ["Jane-Terziev"]
  spec.email         = ["janeterziev@gmail.com"]

  spec.summary       = "Configurable authorization module"
  spec.description   = "Configurable authorization module with the goal of reusing it in microservices"
  spec.homepage      = "https://github.com/Jane-Terziev/authorization-module"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Jane-Terziev/authorization-module"
  spec.metadata["changelog_uri"] = "https://github.com/Jane-Terziev/authorization-module"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rails"
  spec.add_dependency "rake"


  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
