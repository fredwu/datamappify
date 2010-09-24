if defined?(Rails::Railtie)
  module Datamappify
    class Railtie < Rails::Railtie
      rake_tasks do
        load File.expand_path("../../tasks/datamappify.rake", __FILE__)
        load File.expand_path("../../../vendor/auto_migrations/lib/tasks/auto_migrations_tasks.rake", __FILE__)
      end
    end
  end
end