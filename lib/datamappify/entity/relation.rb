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
          create_attribute "#{related_entity_name}_id", Integer
          create_accessor related_entity_name
        end

        private

        # @param related_entity_name (see #references)
        #
        # @return [void]
        def create_accessor(related_entity_name)
          class_eval <<-CODE, __FILE__, __LINE__ + 1
            attr_reader :#{related_entity_name}

            def #{related_entity_name}=(entity)
              @#{related_entity_name}        = entity
              self.#{related_entity_name}_id = entity.id
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
      end
    end
  end
end
