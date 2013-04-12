module Datamappify
  module Repository
    module QueryMethod
      class Save
        include Helper

        # @param mapper [Data::Mapper]
        # @param entity_or_entities [Entity, Array<Entity>] an entity or a collection of entities
        def initialize(mapper, entity_or_entities)
          @mapper             = mapper
          @entity_or_entities = entity_or_entities
        end

        # @return [Entity, Array<Entity>, false]
        def result
          Array.wrap(@entity_or_entities).each do |entity|
            create_or_update(entity)
          end

          @entity_or_entities
        rescue Data::EntityInvalid
          false
        end

        private

        # @param entity [Entity]
        # @raise [Data::EntityInvalid]
        # @return [Entity]
        def create_or_update(entity)
          raise Data::EntityInvalid.new(entity) if entity.invalid?

          dispatch_criteria_to_providers(entity, :SaveByKey)

          entity
        end
      end
    end
  end
end
