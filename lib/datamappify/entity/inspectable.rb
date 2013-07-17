module Datamappify
  module Entity
    module Inspectable
      def self.included(klass)
        klass.extend ClassMethods
      end

      def inspect
        inspectable = self.attributes.map { |name, value| "#{name}: #{value.inspect}" }.join(", ")

        "#<#{self.class} #{inspectable}>"
      end

      module ClassMethods
        def inspect
          inspectable = self.attribute_set.map { |attribute| "#{attribute.name}: #{attribute.class.primitive}" }.join(", ")

          "#<#{name} #{inspectable}>"
        end
      end
    end
  end
end

