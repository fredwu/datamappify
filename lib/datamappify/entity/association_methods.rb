require 'datamappify/entity/associated_entity'
require 'datamappify/entity/associated_collection'

module Datamappify
  module Entity
    module AssociationMethods
      def belongs_to(name, *args)
        AssociatedEntity.new(self, name)
      end

      def has_one(name, *args)
        AssociatedEntity.new(self, name)
      end

      def has_many(name, *args)
        AssociatedCollection.new(self, name)
      end

      def has_and_belongs_to_many(name, *args)
        AssociatedCollection.new(self, name)
      end
    end
  end
end
