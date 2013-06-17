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
          setup_attributes(entity_class, options)
          setup_validators(entity_class, options)
          run_validators
        end

        private

        # @param (see #attributes_from)
        #
        # @return (see #attributes_from)
        def setup_attributes(entity_class, options)
          entity_class.attribute_set.each do |attribute|
            unless excluded_attributes(entity_class).include?(attribute.name)
              self.attribute_set << tweak_attribute(attribute.dup, options)
            end
          end
        end

        # @param (see #attributes_from)
        #
        # @return (see #attributes_from)
        def setup_validators(entity_class, options)
          if options[:prefix_with]
            rename_validators(entity_class, options[:prefix_with])
          else
            entity_class._validators.each { |k, v| self._validators[k] = v.dup }
          end
        end

        # @return [void]
        def run_validators
          self._validators.each do |_, validators|
            validators.each do |validator|
              validate(validator, validator.options)
            end
          end
        end

        # @param entity_class [Entity]
        #
        # @param prefix [Symbol]
        #
        # @return [void]
        def rename_validators(entity_class, prefix)
          entity_class._validators.each do |attribute_name, validators|
            self._validators[:"#{prefix}_#{attribute_name}"] = validators.map do |validator|
              rename_validator_attributes(validator.dup, prefix)
            end
          end
        end

        # @param validator [Validator]
        #
        # @param prefix (see #rename_validators)
        #
        # @return [void]
        def rename_validator_attributes(validator, prefix)
          validator.instance_variable_set :@attributes, validator.attributes.map { |name| :"#{prefix}_#{name}" }
          validator
        end

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
        def tweak_attribute(attribute, options)
          prefix_attribute_name(attribute, options[:prefix_with]) if options[:prefix_with]

          attribute
        end

        # @param attribute [Virtus::Attribute]
        #
        # @param prefix [Symbol]
        #
        # @return [void]
        def prefix_attribute_name(attribute, prefix)
          name = attribute.instance_variable_set :@name, :"#{prefix}_#{attribute.name}"
          attribute.instance_variable_set :@instance_variable_name, "@#{name}".to_sym
        end
      end
    end
  end
end
