# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'datamappify/version'

Gem::Specification.new do |spec|
  spec.name          = "datamappify"
  spec.version       = Datamappify::VERSION
  spec.authors       = ["Fred Wu"]
  spec.email         = ["ifredwu@gmail.com"]
  spec.description   = %q{Compose and manage domain logic and data persistence separately and intelligently.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/fredwu/datamappify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus",      ">= 1.0.0.beta0", "<= 2.0"
  spec.add_dependency "activemodel", ">= 4.0.0.rc1", "< 5"
  spec.add_dependency "hooks",       "~> 0.3.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "cane"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "sequel"
  spec.add_development_dependency "activerecord",     ">= 4.0.0.rc1", "< 5"
  spec.add_development_dependency "database_cleaner", "~> 1.0.1"
end
