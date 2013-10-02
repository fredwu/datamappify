module Datamappify
  module Repository
    module UnitOfWork
      class PersistentStates
        # an object that mirrors an entity's attributes and their initial (clean) values
        class Object
          include ActiveModel::Dirty

          # @param entity [Entity]
          def initialize(entity)
            @entity = entity

            attributes = attributes_for(@entity)
            attributes.each do |name, value|
              construct_attribute(name)
              set_value(name, value)
            end

            self.class.define_attribute_methods(attributes.keys)

            mark_as_dirty if new?
          end

          # Updates all the attribute values according to the entity
          #
          # @param entity [Entity]
          #
          # @return [void]
          def update_values(entity)
            attributes_for(entity).each do |name, value|
              construct_attribute(name)
              send("#{name}=", value)
            end
          end

          # Mark selected or all attributes as dirty, useful for a non-persisted object
          # or for manually trigger attributes update
          #
          # @param attrs [Symbol]
          #   An array or a hash of which the keys are attribute symbols
          #
          # @return [void]
          def mark_as_dirty(*attributes)
            attributes = attributes.any? ? attributes : attributes_for(@entity)
            attributes.each do |name, _|
              send(:attribute_will_change!, name)
            end
          end

          # Is the object new (not persisted yet)?
          #
          # @return [Boolean]
          def new?
            !@entity.persisted?
          end

          private

          # Constructs an attribute with a getter, setter and '_changed?' method
          #
          # @return [void]
          def construct_attribute(name)
            construct_getter(name)
            construct_setter(name)
            construct_changed(name)
          end

          # Constructs an attribute getter
          #
          # @param name [Symbol]
          #
          # @return [void]
          def construct_getter(name)
            define_singleton_method name do
              instance_variable_get "@#{name}"
            end
          end

          # Constructs an attribute setter
          #
          # The setter sets the `attr_will_change!` flag when necessary.
          #
          # @param name [Symbol]
          #
          # @return [void]
          def construct_setter(name)
            define_singleton_method "#{name}=" do |value|
              mark_as_dirty(name) unless send(name) == value
              set_value(name, value)
            end
          end

          # Constructs the `attr_changed?` method
          #
          # @param name [Symbol]
          #
          # @return [void]
          def construct_changed(name)
            define_singleton_method "#{name}_changed?" do
              changed_attributes.include?(name)
            end
          end

          # Sets an attribute value by making a copy of the data
          #
          # @param name [Symbol]
          #
          # @param value [any]
          #
          # @return [any]
          def set_value(name, value)
            instance_variable_set "@#{name}", Marshal.load(Marshal.dump(value))
          end

          # Entity attributes, based on whether the entity is lazy loaded
          #
          # @param entity [Entity]
          #
          # @return [Hash]
          def attributes_for(entity)
            entity.lazy_loaded? ? entity.cached_attributes : entity.attributes
          end
        end
      end
    end
  end
end
