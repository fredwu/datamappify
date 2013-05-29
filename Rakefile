require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['spec/spec_helper', 'spec/**/*_spec.rb']
  t.verbose = true
end

begin
  require 'cane/rake_task'

  desc "Run cane to check quality metrics"
  Cane::RakeTask.new(:quality) do |cane|
    cane.abc_max       = 12
    cane.no_doc        = true
    cane.style_glob    = './lib/**/*.rb'
    cane.style_measure = 120
    cane.abc_exclude   = []
  end
rescue LoadError
  warn "cane not available, quality task not provided."
end

task :default => [:test, :quality]
