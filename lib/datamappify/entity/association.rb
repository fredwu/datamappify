require 'datamappify/entity/association/reference'

module Datamappify
  module Entity
    module Association
      def self.included(klass)
        klass.class_eval do
          include Reference
          extend  DSL
        end
      end

      module DSL
        # @param name [Symbol, String]
        #
        # @param options [Hash]
        #
        # @return [void]
        def belongs_to(name, options = {})
          references name
        end

        # @param name [Symbol, String]
        #
        # @param options [Hash]
        #
        # @return [void]
        def has_many(name, options = {})
          attribute name, Array[options[:via]]
        end
      end
    end
  end
end
