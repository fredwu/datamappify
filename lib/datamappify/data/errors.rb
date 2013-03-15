module Datamappify
  module Data
    class Error < StandardError
    end

    class EntityInvalid < Error
      def initialize(entity)
        super entity.errors.full_messages.join(', ')
      end
    end

    class EntityNotSaved < Error
    end

    class EntityNotDestroyed < Error
    end
  end
end
