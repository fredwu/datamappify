module Datamappify
  module Data
    class Error < StandardError
      attr_reader :errors
      attr_reader :entity

      def initialize(errors = nil)
        super

        @errors = errors
        @entity = errors.instance_variable_get(:@base)
      end
    end

    class EntityInvalid < Error
    end

    class EntityNotSaved < Error
    end

    class EntityNotDestroyed < Error
    end

    class EntityAttributeInvalid < Error
    end
  end
end
