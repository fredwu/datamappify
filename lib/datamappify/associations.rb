module Datamappify
  module Associations
    module ClassMethods
      def belongs_to(association_id, options = {})
        foreign_key = options.include?(:foreign_key) ? options[:foreign_key] : association_id.to_s.foreign_key
        property(foreign_key.to_sym, :integer)
      end
    end
  end
end