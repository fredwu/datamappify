module Datamappify
  module Data
    class Util
      class << self
        def attributes_filtered_by(entity, attribute_names)
          entity.attributes.select { |attr| attribute_names.include?(attr) }
        end
      end
    end
  end
end
