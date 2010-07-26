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
        reflection = self.send :create_has_and_belongs_to_many_reflection, association_id, {}
        Associations.join_tables[reflection.options[:join_table]] = [reflection.association_foreign_key, reflection.primary_key_name]
      end
    end
  end
end