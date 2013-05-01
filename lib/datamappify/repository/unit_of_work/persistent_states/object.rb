module Datamappify
  module Repository
    module UnitOfWork
      class PersistentStates
        # an object that mirrors an entity's attributes and their initial (clean) values
        class Object
          include ActiveModel::Dirty

          # @param entity [Entity]
          def initialize(entity)
            self.class.define_attribute_methods entity.attributes.keys

            entity.attributes.each do |name, value|
              construct_getter(name)
              construct_setter(name)
              set_value(name, value)
            end
          end

          # Updates all the attribute values according to the entity
          #
          # @param entity [Entity]
          #
          # @return [void]
          def update_values(entity)
            entity.attributes.each do |name, value|
              send("#{name}=", value)
            end
          end

          private

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

          # Constructs an attribute setter, the setter itself does NOT need
          # to set the value as the value is never going to be used.
          #
          # The setter sets the `attr_will_change!` flag when necessary.
          #
          # @param name [Symbol]
          #
          # @return [void]
          def construct_setter(name)
            define_singleton_method "#{name}=" do |value|
              send "#{name}_will_change!" unless send(name) == value
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
        end
      end
    end
  end
end
