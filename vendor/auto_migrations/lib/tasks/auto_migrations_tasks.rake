namespace :db do
  namespace :auto do
    desc "Use schema.rb to auto-migrate"
    task :migrate => :environment do
      AutoMigrations.run
    end 
  end
  
  namespace :schema do
    desc "Create migration from schema.rb"
    task :to_migration => :environment do
      AutoMigrations.schema_to_migration
    end

    desc "Create migration from schema.rb and reset migrations log"
    task :to_migration_with_reset => :environment do
      AutoMigrations.schema_to_migration(true)
    end
  end
end
