module Datamappify
  module Entity
    module Relation
      def self.included(klass)
        klass.class_eval do
          cattr_accessor :reference_keys
          extend DSL

          self.reference_keys = []
        end
      end

      module DSL
        # @param entity_name [Symbol, String]
        #
        # @return [void]
        def references(entity_name)
          attribute_name = :"#{entity_name}_id"

          create_attribute attribute_name, Integer
          create_accessor entity_name
          record_attribute attribute_name
        end

        private

        # @param entity_name (see #references)
        #
        # @return [void]
        def create_accessor(entity_name)
          class_eval <<-CODE, __FILE__, __LINE__ + 1
            attr_reader :#{entity_name}

            def #{entity_name}=(entity)
              @#{entity_name}        = entity
              self.#{entity_name}_id = entity.nil? ? nil : entity.id
            end
          CODE
        end

        # @param name [Symbol]
        #
        # @param type [Class]
        #
        # @param options [any]
        #
        # @return [void]
        def create_attribute(name, type, *args)
          attribute name, type, *args
        end

        # @param attribute_name [Symbol]
        #
        # @return [Array]
        def record_attribute(attribute_name)
          self.reference_keys << attribute_name
        end
      end
    end
  end
end
