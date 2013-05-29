module Datamappify
  module Entity
    module Relation
      def self.included(klass)
        klass.extend DSL
      end

      module DSL
        # @param related_entity_name [Symbol, String]
        #
        # @return [void]
        def references(related_entity_name)
          attribute "#{related_entity_name}_id", Integer
        end
      end
    end
  end
end
