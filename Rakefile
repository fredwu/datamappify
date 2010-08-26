require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "datamappify"
    s.summary = "Turn ActiveRecord into DataMapper (sort of)!"
    s.description = "ActiveRecord is without doubt the de facto ORM library for Rails and many Ruby web frameworks. Many developers however, do not like database migrations and prefer to use DSL for data mapping. Datamappify is created with the sole purpose of getting rid of the DB migration headaches."
    s.email = "ifredwu@gmail.com"
    s.homepage = "http://github.com/fredwu/datamappify"
    s.authors = ["Fred Wu"]
    s.require_paths = ["lib", "vendor/auto_migrations/lib"]
    s.add_dependency("activerecord")
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
