module Datamappify
  module Lazy
    # Overrides attribute setters and getters for lazy loading
    class AttributesHandler
      # @return [Array]
      attr_accessor :uncached_attributes

      # @param entity [Entity]
      def initialize(entity)
        @entity              = entity
        @uncached_attributes = entity.attributes.keys - entity.class::IGNORED_ATTRIBUTE_NAMES

        entity.add_observer(self)
      end

      # Triggers only when a reader query (e.g. {Repository::QueryMethod::Find}) is performed
      #
      # @param (see Repository::QueryMethod::Method::SourceAttributesWalker#walk_performed)
      def update(query_method, attributes)
        if query_method && query_method.reader?
          cache_attributes!
          uncached_attributes.each { |name| override_attribute(name) }
        end
      end

      private

      # @see Data::Mapper#attributes
      #
      # @return (see Data::Mapper#attributes)
      def all_attributes
        @all_attributes ||= @entity.repository.data_mapper.attributes
      end

      # Removes the cached attributes from the uncached attributes array
      #
      # @return [void]
      def cache_attributes!
        @uncached_attributes = @uncached_attributes - @entity.cached_attributes.keys
      end

      # Overrides attribute setters and getters
      #
      # @param name [Symbol]
      #
      # @return [void]
      def override_attribute(name)
        override_attribute_setter(name)
        override_attribute_getter(name)
      end

      # @param (see #override_attribute)
      #
      # @return [void]
      def override_attribute_setter(name)
        @entity.define_singleton_method "#{name}=" do |value|
          super(value)

          self.define_singleton_method name do
            instance_variable_set "@#{name}", value
          end
        end
      end

      # @param (see #override_attribute)
      #
      # @return [void]
      def override_attribute_getter(name)
        entity     = @entity
        attributes = attributes_from_same_source(name)

        entity.define_singleton_method name do
          Logger.performed(:override_attribute, name)

          AttributesHandler.walk_attributes(name, entity, attributes)

          instance_variable_get "@#{name}"
        end
      end

      # @param name [Symbol]
      #
      # @return [Set<Data::Mapper::Attribute>]
      def attributes_from_same_source(name)
        source_class_name = attribute_by_name(name).source_class_name

        attributes = all_attributes.select do |attribute|
          attribute.source_class_name == source_class_name
        end

        Set.new(attributes)
      end

      # @param name [Symbol]
      #
      # @return [Data::Mapper::Attribute]
      def attribute_by_name(name)
        all_attributes.find { |attribute| attribute.key == name }
      end

      class << self
        # @param name [Symbol]
        #
        # @param attributes [Set<Data::Mapper::Attribute>]
        #
        # @return [void]
        def walk_attributes(name, entity, attributes)
          SourceAttributesWalker.new({
            :entity           => entity,
            :provider_name    => attributes.first.provider_name,
            :attributes       => attributes,
            :dirty_aware?     => true,
            :dirty_attributes => []
          }).execute do |provider_name, source_class, attributes|
            entity.repository.data_mapper.provider(provider_name).build_criteria(
              :FindByKey, source_class, entity, attributes
            )
          end
        end
      end
    end
  end
end
