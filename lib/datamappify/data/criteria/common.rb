module Datamappify
  module Data
    module Criteria
      # Provides a set of useful methods for common criteria tasks,
      # all +Criteria+ objects inherit from +Common+
      class Common
        # @return [Class]
        attr_reader :source_class

        # @return [Entity]
        attr_reader :entity

        # @return [void]
        attr_reader :criteria

        # @return [Set<Mapper::Attribute>]
        attr_reader :attributes

        # @param source_class [Class]
        #
        # @param args [any]
        #
        # @yield
        #   an optional block
        def initialize(source_class, *args, &block)
          @source_class = source_class
          @entity, @criteria, @attributes = *args
          @block = block
        end

        # Performs the action (defined by child method classes) with callbacks
        #
        # @return [void]
        def perform_with_callbacks
          result = perform

          store_attribute_value if attributes

          result
        end

        protected

        # Name of the default source class, e.g. +"User"+,
        # it is determined from either the PK or the entity
        #
        # @return [String]
        def default_source_class_name
          @default_source_class_name ||= pk ? pk.source_class_name : entity.class.name.demodulize
        end

        # Key name of either the primary key (e.g. +id+) or foreign key (e.g. +user_id+)
        #
        # @return [Symbol]
        def key_name
          primary_record? ? :id : any_attribute.primary_reference_key
        end

        # The value of {#key_name}
        #
        # @return [void]
        def key_value
          criteria.with_indifferent_access[key_name]
        end

        # Determines whether or not it's going to be a new record by looking at the {#key_value}
        #
        # @return [Boolean]
        def new_record?
          key_value.nil?
        end

        # Determines whether or not it's a primary record by comparing the source class and the entity class
        #
        # @return [Boolean]
        def primary_record?
          source_class.name.demodulize == default_source_class_name
        end

        # Ignores the current Criteria's operation if there is no dirty attributes
        #
        # @return [Boolean]
        def ignore?
          attributes_and_values.empty?
        end

        # Attributes with their corresponding values
        #
        # @return [Hash]
        def attributes_and_values
          @attributes_and_values ||= begin
            hash = {}

            attributes.each do |attribute|
              unless ignore_attribute?(attribute)
                hash[attribute.source_attribute_name] = entity.send(attribute.name)
              end
            end

            hash
          end
        end

        # Stores the attribute value in {Mapper::Attribute} for later use
        #
        # @return [void]
        def store_attribute_value
          attributes.each do |attribute|
            attribute.value = entity.instance_variable_get("@#{attribute.name}")
          end
        end

        # @return [Attribute]
        def any_attribute
          @any_attribute ||= attributes.first
        end

        # @return [Attribute]
        def pk
          @pk ||= attributes.find { |attribute| attribute.key == :id }
        end

        private

        # Ignores the attribute if it isn't dirty or if it's a primary key
        #
        # @todo implement proper dirty attribute tracking
        #
        # @return [Boolean]
        def ignore_attribute?(attribute)
          entity.send(attribute.name).nil? || attribute.primary_key?
        end
      end
    end
  end
end
