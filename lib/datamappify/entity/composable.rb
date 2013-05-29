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
          entity_class.attribute_set.each do |attribute|
            unless excluded_attributes(entity_class).include?(attribute.name)
              self.attribute_set << tweak_attribute!(attribute, options)
            end
          end
        end

        private

        # @param entity_class [Entity]
        #
        # @return [Array]
        def excluded_attributes(entity_class)
          @excluded_attributes ||= entity_class.reference_keys << :id
        end

        # @param attribute [Virtus::Attribute]
        #
        # @param options [Hash]
        #
        # @return [Virtus::Attribute]
        def tweak_attribute!(attribute, options)
          prefix_attribute_name!(attribute, options[:prefix_with]) if options[:prefix_with]

          attribute
        end

        # @param attribute [Virtus::Attribute]
        #
        # @param prefix [Symbol]
        #
        # @return [void]
        def prefix_attribute_name!(attribute, prefix)
          attribute.instance_variable_set :@name, :"#{prefix}_#{attribute.name}"
        end
      end
    end
  end
end
