require 'datamappify/entity/composable/attribute'
require 'datamappify/entity/composable/attributes'
require 'datamappify/entity/composable/validators'

module Datamappify
  module Entity
    module Composable
      def self.included(klass)
        klass.extend DSL
      end

      module DSL
        # @param entity_class [Entity]
        #
        # @param options [Hash]
        #
        # @return [void]
        def attributes_from(entity_class, options = {})
          Attributes.build(self, entity_class, options)
          Validators.build(self, entity_class, options)
        end
      end
    end
  end
end
