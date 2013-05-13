module Datamappify
  module Repository
    module LazyChecking
      # Is the repository for an entity that requires lazy loading?
      #
      # @return [Boolean]
      def lazy_load?
        data_mapper.entity_class.included_modules.include?(Datamappify::Lazy)
      end

      # Assign the repository itself to the lazy entity
      #
      # @return [void]
      def assign_to_entity
        data_mapper.entity_class.repository = self
      end
    end
  end
end
