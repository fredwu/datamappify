module Datamappify
  module Data
    class Error < StandardError
    end

    class MethodNotImplemented < NoMethodError
    end

    class EntityInvalid < Error
      attr_reader :entity

      # @param entity [Entity]
      def initialize(entity)
        @entity = entity
        super entity.errors.full_messages.join(', ')
      end
    end

    class EntityNotSaved < Error
    end

    class EntityNotDestroyed < Error
    end

    class EntityAttributeInvalid < Error
    end
  end
end
