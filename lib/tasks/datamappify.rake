namespace :db do
  namespace :schema do
    desc "Update schema.rb with Datamappfiy"
    task :update => :environment do
      Datamappify::SchemaDumper.dump_to_file
      Rake::Task["db:schema:update"].reenable
    end
    
    desc "Auto-migrate via schema.rb"
    task :auto_migrate => :environment do
      Rake::Task["db:schema:update"].invoke
      Rake::Task["db:auto:migrate"].invoke
    end
  end
end