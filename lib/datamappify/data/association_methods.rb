module Datamappify
  module Data
    module AssociationMethods
      def belongs_to(name, scope = nil, options = {})
        build_associated_repository(name)

        super(name, scope = nil, options)
      end

      def has_one(name, scope = nil, options = {})
        build_associated_repository(name)

        super(name, scope = nil, options)
      end

      def has_many(name, scope = nil, options = {}, &extension)
        build_associated_repository(name)

        super(name, scope = nil, options, &extension)
      end

      private

      def build_associated_repository(entity_or_collection_name)
        Datamappify::Repository.new(entity_or_collection_name.to_s.classify.constantize)
      end
    end
  end
end
