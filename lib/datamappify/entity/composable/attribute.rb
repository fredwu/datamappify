module Datamappify
  module Entity
    module Composable
      class Attribute
        # @param name [Virtus::Attribute]
        #
        # @param prefix [Symbol]
        #
        # @return [void]
        def self.prefix(name, prefix)
          :"#{prefix}_#{name}"
        end
      end
    end
  end
end
