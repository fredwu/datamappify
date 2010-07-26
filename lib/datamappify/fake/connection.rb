module Datamappify
  module Fake
    class Connection
      def columns(table)
        @primary_key = "id"
        resource     = get_resource(table)
        columns      = []
        
        # manually add the primary key property (without the :primary_key option)
        # as ActiveRecord ignores the primary_key column
        add_primary_key_to(resource) unless is_a_join_table?(table)
        
        resource[:properties].map do |property|
          if (property[:name] == :timestamps)
            create_timestamps_for(resource)
          else
            columns << Column.new(property)
          end
        end
        
        columns
      end
      
      def primary_key(table)
        resource = get_resource(table)
        primary_key_for(resource)
      end
      
      def indexes(table)
        resource = get_resource(table)
        resource[:indexes].map do |index|
          Index.new(resource, index)
        end
      end
      
      private
      
      def get_resource(table)
        Collection.get.select do |r|
          r[:table_name].to_s == table.to_s
        end[0]
      end
      
      def create_timestamps_for(resource)
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
      
      def primary_key_for(resource)
        resource[:properties].select do |property|
          return property[:name].to_s if property[:options][:primary_key]
        end
        "id"
      end
      
      def add_primary_key_to(resource)
        resource[:properties] << {
          :name     => primary_key_for(resource),
          :sql_type => :datetime,
          :options  => {},
        }
      end
      
      def is_a_join_table?(table)
        Associations.join_tables.key?(table)
      end
    end
  end
end