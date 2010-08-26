module AutoMigrations
  
  def self.run
    # Turn off schema_info code for auto-migration
    class << ActiveRecord::Schema
      alias :old_define :define
      attr_accessor :version
      def define(info={}, &block) @version = Time.now.utc.strftime("%Y%m%d%H%M%S"); instance_eval(&block) end
    end
  
    load(Rails.root.join('db', 'schema.rb'))
    ActiveRecord::Migration.drop_unused_tables
    ActiveRecord::Migration.drop_unused_indexes
    ActiveRecord::Migration.update_schema_version(ActiveRecord::Schema.version) if ActiveRecord::Schema.version
  
    class << ActiveRecord::Schema
      alias :define :old_define
    end
  end
  
  def self.schema_to_migration(with_reset = false)
    schema_in = File.read(Rails.root.join("db", "schema.rb"))
    schema_in.gsub!(/#(.)+\n/, '')
    schema_in.sub!(/ActiveRecord::Schema.define(.+)do[ ]?\n/, '')
    schema_in.gsub!(/^/, '  ')
    schema = "class InitialSchema < ActiveRecord::Migration\n  def self.up\n" 
    schema += "    # We're resetting the migrations database...\n" +
              "    drop_table :schema_migrations\n" +
              "    initialize_schema_migrations_table\n\n" if with_reset
    schema += schema_in
    schema << "\n  def self.down\n"
    schema << (ActiveRecord::Base.connection.tables - %w(schema_info schema_migrations)).map do |table| 
                "    drop_table :#{table}\n"
              end.join
    schema << "  end\nend\n"
    migration_file = Rails.root.join("db", "migrate", "001_initial_schema.rb")
    File.open(migration_file, "w") { |f| f << schema }
    puts "Migration created at db/migrate/001_initial_schema.rb"
  end
  
  def self.included(base)
    base.extend ClassMethods
    class << base
      cattr_accessor :tables_in_schema, :indexes_in_schema
      self.tables_in_schema, self.indexes_in_schema = [], []
      alias_method_chain :method_missing, :auto_migration
    end
  end

  module ClassMethods
  
    def method_missing_with_auto_migration(method, *args, &block)
      case method
      when :create_table
        auto_create_table(method, *args, &block)
      when :add_index
        auto_add_index(method, *args, &block)
      else
        method_missing_without_auto_migration(method, *args, &block) 
      end
    end
    
    def auto_create_table(method, *args, &block)
      table_name = args.shift.to_s    
      options    = args.pop || {}
        
      (self.tables_in_schema ||= []) << table_name

      # Table doesn't exist, create it
      unless ActiveRecord::Base.connection.tables.include?(table_name)
        return method_missing_without_auto_migration(method, *[table_name, options], &block)
      end
    
      # Grab database columns
      fields_in_db = ActiveRecord::Base.connection.columns(table_name).inject({}) do |hash, column|
        hash[column.name] = column
        hash
      end
    
      # Grab schema columns (lifted from active_record/connection_adapters/abstract/schema_statements.rb)
      table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new(ActiveRecord::Base.connection)
      primary_key = options[:primary_key] || "id"
      table_definition.primary_key(primary_key) unless options[:id] == false
      yield table_definition
      fields_in_schema = table_definition.columns.inject({}) do |hash, column|
        hash[column.name.to_s] = column
        hash
      end
    
      # Add fields to db new to schema
      (fields_in_schema.keys - fields_in_db.keys).each do |field|
        column  = fields_in_schema[field]
        options = {:limit => column.limit, :precision => column.precision, :scale => column.scale}
        options[:default] = column.default.to_s if !column.default.nil?
        options[:null]    = column.null    if !column.null.nil?
        add_column table_name, column.name, column.type.to_sym, options
      end
    
      # Remove fields from db no longer in schema
      (fields_in_db.keys - fields_in_schema.keys & fields_in_db.keys).each do |field|
        column = fields_in_db[field]
        remove_column table_name, column.name
      end
      
      (fields_in_schema.keys & fields_in_db.keys).each do |field|
        if field != primary_key #ActiveRecord::Base.get_primary_key(table_name)
          changed  = false  # flag
          new_type = fields_in_schema[field].type.to_sym
          new_attr = {}

          # First, check if the field type changed
          if fields_in_schema[field].type.to_sym != fields_in_db[field].type.to_sym
            changed = true
          end

          # Special catch for precision/scale, since *both* must be specified together
          # Always include them in the attr struct, but they'll only get applied if changed = true
          new_attr[:precision] = fields_in_schema[field][:precision]
          new_attr[:scale]     = fields_in_schema[field][:scale]

          # Next, iterate through our extended attributes, looking for any differences
          # This catches stuff like :null, :precision, etc
          fields_in_schema[field].each_pair do |att,value|
            next if att == :type or att == :base or att == :name # special cases
            if !value.nil? && value != fields_in_db[field].send(att)
              new_attr[att] = value
              changed = true
            end
          end

          # Change the column if applicable
          change_column table_name, field, new_type, new_attr if changed
        end
      end
    end
    
    def auto_add_index(method, *args, &block)      
      table_name = args.shift.to_s
      fields     = Array(args.shift).map(&:to_s)
      options    = args.shift

      index_name = options[:name] if options  
      index_name ||= ActiveRecord::Base.connection.index_name(table_name, :column => fields)

      (self.indexes_in_schema ||= []) << index_name

      unless ActiveRecord::Base.connection.indexes(table_name).detect { |i| i.name == index_name }
        method_missing_without_auto_migration(method, *[table_name, fields, options], &block)
      end
    end
  
    def drop_unused_tables
      (ActiveRecord::Base.connection.tables - tables_in_schema - %w(schema_info schema_migrations)).each do |table|
        drop_table table
      end
    end
    
    def drop_unused_indexes
      tables_in_schema.each do |table_name|
        indexes_in_db = ActiveRecord::Base.connection.indexes(table_name).map(&:name)
        (indexes_in_db - indexes_in_schema & indexes_in_db).each do |index_name|
          remove_index table_name, :name => index_name
        end
      end
    end
    
    def update_schema_version(version)
      ActiveRecord::Base.connection.update("INSERT INTO schema_migrations VALUES ('#{version}')")

      schema_file = Rails.root.join("db", "schema.rb")
      schema = File.read(schema_file)
      schema.sub!(/:version => \d+/, ":version => #{version}")
      File.open(schema_file, "w") { |f| f << schema }
    end
  
  end

end
