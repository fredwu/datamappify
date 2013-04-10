module Datamappify
  module Data
    module Criteria
      class Common
        attr_reader :source_class, :entity, :criteria, :attributes

        def initialize(source_class, *args, &block)
          @source_class = source_class
          @entity, @criteria, @attributes = *args
          @block = block
        end

        protected

        def key_name
          primary_record? ? :id : "#{entity.class.name.demodulize.underscore}_id".to_sym
        end

        def key_value
          criteria.with_indifferent_access[key_name]
        end

        def new_record?
          key_value.nil?
        end

        def primary_record?
          source_class.name.demodulize == entity.class.name.demodulize
        end

        def ignore?
          attributes_and_values.empty?
        end

        def attributes_and_values
          hash = {}

          attributes.each do |attribute|
            unless ignore_attribute?(attribute)
              hash[attribute.source_attribute_name] = entity.send(attribute.name)
            end
          end

          hash
        end

        private

        def ignore_attribute?(attribute)
          entity.send(attribute.name).nil? || attribute.primary_key?
        end
      end
    end
  end
end
