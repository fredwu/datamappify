module Datamappify
  module Repository
    module QueryMethod
      class Destroy < Method
        # @param mapper (see Method#initialize)
        #
        # @param id_or_ids_or_entity_or_entities [Entity, Array<Entity>]
        #   an entity or a collection of ids or entities
        def initialize(mapper, id_or_ids_or_entity_or_entities)
          super
          @id_or_ids_or_entity_or_entities = id_or_ids_or_entity_or_entities
        end

        # @return [void, false]
        def result
          entities = Array.wrap(@id_or_ids_or_entity_or_entities).map do |id_or_entity|
            dispatch_criteria_to_default_source(:Destroy, extract_entity_id(id_or_entity))
          end

          @id_or_ids_or_entity_or_entities.is_a?(Array) ? entities : entities[0]
        end
      end
    end
  end
end
