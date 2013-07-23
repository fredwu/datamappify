module Datamappify
  module Entity
    module Inspectable
      def self.included(klass)
        klass.extend ClassMethods
      end

      def inspect
        inspectable = self.attributes.map do |name, value|
          "#{name}: #{value.inspect}"
        end.join(", ")

        "#<#{self.class} #{inspectable}>"
      end

      module ClassMethods
        def inspect
          inspectable = self.attribute_set.map do |attribute|
            "#{attribute.name}: #{attribute.class.primitive}"
          end.join(", ")

          "#<#{name} #{inspectable}>"
        end
      end
    end
  end
end
