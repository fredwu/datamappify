module Datamappify
  module Associations
    mattr_accessor :join_tables
    
    @@join_tables = {}
    
    module ClassMethods
      def belongs_to(association_id, options = {})
        foreign_key = options.include?(:foreign_key) ? options[:foreign_key] : association_id.to_s.foreign_key
        property(foreign_key.to_sym, :integer)
      end
      
      def has_and_belongs_to_many(association_id, options = {}, &extension)
        join_table_name         = options.include?(:join_table) ?
                                  options[:join_table] : join_table_name(table_name, association_id.to_s.classify.constantize.table_name)
        foreign_key             = options.include?(:foreign_key) ? options[:foreign_key] : self.to_s.foreign_key
        association_foreign_key = options.include?(:association_foreign_key) ?
                                  options[:association_foreign_key] : association_id.to_s.classify.to_s.foreign_key
        
        Associations.join_tables[join_table_name] = [foreign_key, association_foreign_key]
      end
      
      private
      
      # taken from ActiveRecord::Associations::ClassMethods
      def join_table_name(first_table_name, second_table_name)
        if first_table_name < second_table_name
          join_table = "#{first_table_name}_#{second_table_name}"
        else
          join_table = "#{second_table_name}_#{first_table_name}"
        end

        table_name_prefix + join_table + table_name_suffix
      end
    end
  end
end