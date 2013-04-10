module Datamappify
  module Repository
    module QueryMethod
      class Destroy
        def initialize(mapper, id_or_ids_or_entity_or_entities)
          @mapper                          = mapper
          @id_or_ids_or_entity_or_entities = id_or_ids_or_entity_or_entities
        end

        def result
          ids = Array.wrap(@id_or_ids_or_entity_or_entities).map do |id_or_entity|
            id = id_or_entity.is_a?(Integer) ? id_or_entity : id_or_entity.id
            @mapper.default_provider.build_criteria(:Destroy, @mapper.default_source_class, id)
          end
        end
      end
    end
  end
end
