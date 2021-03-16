# frozen_string_literal: true

require_relative "lib/named_imports/version"

Gem::Specification.new do |spec|
  spec.name = "named_imports"
  spec.version = NamedImports::VERSION
  spec.authors = ["Keegan Leitz"]
  spec.email = ["kjleitz@gmail.com"]

  spec.summary = "Named imports for Ruby"
  spec.description = "Stop asking where that thing came from."
  spec.homepage = "https://github.com/kjleitz/named_imports"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kjleitz/named_imports"
  spec.metadata["changelog_uri"] = "https://github.com/kjleitz/named_imports/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # `git ls-files -z` loads the files in the RubyGem that are tracked in git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.10"
  spec.add_development_dependency "rubocop-performance", "~> 1.9"
  spec.add_development_dependency "rubocop-rake", "~> 0.5"
  spec.add_development_dependency "rubocop-rspec", "~> 2.2"
  spec.add_development_dependency "solargraph"
end
