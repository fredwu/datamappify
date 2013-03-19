# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'datamappify/version'

Gem::Specification.new do |spec|
  spec.name          = "datamappify"
  spec.version       = Datamappify::VERSION
  spec.authors       = ["Fred Wu"]
  spec.email         = ["ifredwu@gmail.com"]
  spec.description   = %q{Separate domain logic from data persistence.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/fredwu/datamappify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus",        "~> 0.5"
  spec.add_dependency "activesupport", ">= 4.0.0.beta1", "< 5"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "cane"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "activerecord",  ">= 4.0.0.beta1", "< 5"
  spec.add_development_dependency "database_cleaner", ">= 1.0.0.RC1", "< 2"
end
