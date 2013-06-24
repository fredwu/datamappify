module Datamappify
  module Entity
    module Composable
      class Validators
        class << self
          def build(entity, entity_class, options)
            @entity       = entity
            @entity_class = entity_class
            @options      = options

            build_validators
            run_validators
          end

          private

          # @return (see #attributes_from)
          def build_validators
            if @options[:prefix_with]
              rename_validators(@options[:prefix_with])
            else
              @entity_class._validators.each { |k, v| @entity._validators[k] = v.dup }
            end
          end

          # @param prefix [Symbol]
          #
          # @return [void]
          def rename_validators(prefix)
            @entity_class._validators.each do |attribute_name, validators|
              @entity._validators[Attribute.prefix(attribute_name, prefix)] = validators.map do |validator|
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
            validator.instance_variable_set(
              :@attributes,
              validator.attributes.map { |name| Attribute.prefix(name, prefix) }
            )

            validator
          end

          # @return [void]
          def run_validators
            @entity._validators.each do |_, validators|
              validators.each do |validator|
                @entity.validate(validator, validator.options)
              end
            end
          end
        end
      end
    end
  end
end
