module Datamappify
  module Data
    module AssociationMethods
      def belongs_to(*args)
        build_associated_repository(args[0])
        super
      end

      def has_one(*args)
        build_associated_repository(args[0])
        super
      end

      def has_many(*args)
        build_associated_repository(args[0])
        super
      end

      def has_and_belongs_to_many(*args)
        build_associated_repository(args[0])
        super
      end

      private

      def build_associated_repository(entity_or_collection_name)
        Datamappify::Repository.new(entity_or_collection_name.to_s.classify.constantize)
      end
    end
  end
end
