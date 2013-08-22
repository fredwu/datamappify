module Datamappify
  module Repository
    module QueryMethod
      class Save < Method
        # @return [Entity, false]
        def perform
          states.update(entity) do
            create_or_update(entity)
          end

          entity
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
          raise Data::EntityInvalid.new(entity.errors) if entity.invalid?(context)

          dispatch_criteria_to_providers(:SaveByKey, entity)

          entity
        end

        def context
          self.class.name.demodulize.underscore.to_sym
        end
      end
    end
  end
end
