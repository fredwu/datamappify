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
        attr_accessor :criteria

        # @return [Set<Mapper::Attribute>]
        attr_reader :attributes

        # @return [Hash]
        attr_accessor :attributes_and_values

        # @return [Hash]
        attr_reader :options

        # @param source_class [Class]
        #
        # @param args [any]
        #
        # @yield
        #   an optional block
        def initialize(source_class, *args, &block)
          @source_class = source_class
          @entity, @criteria, @attributes, @options = *args
          @block = block

          @criteria ||= {}
          @options  ||= {}
        end

        # Performs the action (defined by child method classes) with callbacks
        #
        # @return [void]
        def perform_with_callbacks
          result = perform

          store_attribute_value if attributes

          result
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
          primary_record? || options[:via] ? :id : any_attribute.reference_key
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
          source_class_name == default_source_class_name
        end

        # Source class name with its namespace but without Data::Record::Provider
        #
        # @return [String]
        def source_class_name
          source_class.name.split('Datamappify::Data::Record::')[-1].split('::', 2)[-1]
        end

        # Ignores the current Criteria's operation if there is no dirty attributes
        #
        # @return [Boolean]
        def ignore?
          attributes_and_values.empty? && !primary_record?
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
          @pk ||= attributes.find(&:primary_key?)
        end

        private

        # Ignores the attribute if it isn't dirty or if it's a primary key
        #
        # @return [Boolean]
        def ignore_attribute?(attribute)
          unchanged_nil_attribute?(attribute) || attribute.primary_key?
        end

        # Check if the attribute is nil, and not changed
        # This ensures that we can set a value _to_ nil if needed.
        #
        # @return [Boolean]
        def unchanged_nil_attribute?(attribute)
          new_value = entity.send(attribute.name)
          old_value = entity_changed_attributes[attribute.key]
          new_value.nil? && old_value.nil?
        end

        # @return [Hash]
        def entity_changed_attributes
          options[:entity_states].fetch(entity).changed_attributes
        end
      end
    end
  end
end
