module Datamappify
  module Entity
    module LazyChecking
      # Whether the entity is lazy loaded
      #
      # @return [Boolean]
      def lazy_loaded?
        self.respond_to?(:repository)
      end
    end
  end
end
