module Datamappify
  module Repository
    module QueryMethod
      class Save < Method
        # @param options (see Method#initialize)
        #
        # @param entity [Entity]
        def initialize(options, entity)
          super
          @entity = entity
        end

        # @return [Entity, false]
        def perform
          states.update(@entity) do
            create_or_update(@entity)
          end

          @entity
        rescue Data::EntityInvalid
          false
        end

        # @see Method#dirty_aware?
        def dirty_aware?
          true
        end

        # @see Method#writer?
        def writer?
          true
        end

        private

        # @param entity [Entity]
        #
        # @raise [Data::EntityInvalid]
        #
        # @return [Entity]
        def create_or_update(entity)
          raise Data::EntityInvalid.new(entity) if entity.invalid?

          dispatch_criteria_to_providers(:SaveByKey, entity)

          entity
        end
      end
    end
  end
end
