module Datamappify
  class SchemaDumper < ActiveRecord::SchemaDumper
    def self.dump_to_file
      File.open(ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb", "w") do |file|
        Datamappify::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
    
    def tables(stream)
      Datamappify::Collection.get.each do |entry|
        tbl = entry[:table_name] or entry[:resource].pluralize
        table(tbl, entry, stream)
      end
    end
    
    def add_timestamps_to(resource)
      resource[:properties] << {
        :name     => :created_at,
        :sql_type => :datetime,
        :options  => {},
      }
      resource[:properties] << {
        :name     => :updated_at,
        :sql_type => :datetime,
        :options  => {},
      }
    end
    
    def table(table, resource, stream)
      columns = []
      resource[:properties].map do |property|
        if (property[:name] == :timestamps)
          add_timestamps_to(resource)
        else
          default    = property[:options].include?(:default) ? property[:options][:default] : nil
          allow_null = property[:options].include?(:null) ? property[:options][:null] : true
        
          columns << ActiveRecord::ConnectionAdapters::Column.new(property[:name], default, property[:sql_type], allow_null)
          
          pk = property[:options][:primary_key] if property[:options].include?(:primary_key)
        end
      end
      
      begin
        tbl = StringIO.new
        
        # first dump primary key column
        pk ||= "id"
        if pk == "id"
          columns.unshift ActiveRecord::ConnectionAdapters::Column.new("id", nil, :integer)
        end
        
        # --------------------------------------------------
        # CODE BELOW ARE COPIED FROM RAILS
        # activerecord/lib/active_record/schema_dumper
        # --------------------------------------------------
        
        tbl.print "  create_table #{table.inspect}"
        if columns.detect { |c| c.name == pk }
          if pk != 'id'
            tbl.print %Q(, :primary_key => "#{pk}")
          end
        else
          tbl.print ", :id => false"
        end
        tbl.print ", :force => true"
        tbl.puts " do |t|"

        # then dump all non-primary key columns
        column_specs = columns.map do |column|
          raise StandardError, "Unknown type '#{column.sql_type}' for column '#{column.name}'" if @types[column.type].nil?
          next if column.name == pk
          spec = {}
          spec[:name]      = column.name.inspect
          
          # AR has an optimisation which handles zero-scale decimals as integers.  This
          # code ensures that the dumper still dumps the column as a decimal.
          spec[:type]      = if column.type == :integer && [/^numeric/, /^decimal/].any? { |e| e.match(column.sql_type) }
                               'decimal'
                             else
                               column.type.to_s
                             end
          spec[:limit]     = column.limit.inspect if column.limit != @types[column.type][:limit] && spec[:type] != 'decimal'
          spec[:precision] = column.precision.inspect if !column.precision.nil?
          spec[:scale]     = column.scale.inspect if !column.scale.nil?
          spec[:null]      = 'false' if !column.null
          spec[:default]   = default_string(column.default) if column.has_default?
          (spec.keys - [:name, :type]).each{ |k| spec[k].insert(0, "#{k.inspect} => ")}
          spec
        end.compact
        
        # find all migration keys used in this table
        keys = [:name, :limit, :precision, :scale, :default, :null] & column_specs.map(&:keys).flatten
        
        # figure out the lengths for each column based on above keys
        lengths = keys.map{ |key| column_specs.map{ |spec| spec[key] ? spec[key].length + 2 : 0 }.max }
        
        # the string we're going to sprintf our values against, with standardized column widths
        format_string = lengths.map{ |len| "%-#{len}s" }
        
        # find the max length for the 'type' column, which is special
        type_length = column_specs.map{ |column| column[:type].length }.max
        
        # add column type definition to our format string
        format_string.unshift "    t.%-#{type_length}s "
        
        format_string *= ''
        
        column_specs.each do |colspec|
          values = keys.zip(lengths).map{ |key, len| colspec.key?(key) ? colspec[key] + ", " : " " * len }
          values.unshift colspec[:type]
          tbl.print((format_string % values).gsub(/,\s*$/, ''))
          tbl.puts
        end
        
        tbl.puts "  end"
        tbl.puts
        
        indexes(table, resource[:indexes], tbl)
        
        tbl.rewind
        stream.print tbl.read
      rescue => e
        stream.puts "# Could not dump table #{table.inspect} because of following #{e.class}"
        stream.puts "#   #{e.message}"
        stream.puts
      end
      
      stream
    end
    
    def indexes(table, indexes, stream)
      unless indexes.empty?
        add_index_statements = indexes.map do |index|
          statement_parts = [ ('add_index ' + table.inspect) ]
          statement_parts << index[:property_name].inspect
          statement_parts << (':name => ' + index[:label].inspect) if index[:label]
          statement_parts << ':unique => true' if index[:unique]

          index_lengths = index[:lengths].compact if index[:lengths].is_a?(Array)
          statement_parts << (':length => ' + Hash[*index.columns.zip(index[:lengths]).flatten].inspect) if index_lengths.present?

          '  ' + statement_parts.join(', ')
        end
        
        stream.puts add_index_statements.sort.join("\n")
        stream.puts
      end
    end
  end
end