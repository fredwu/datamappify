module Datamappify
  module Repository
    module QueryMethod
      class Destroy
        include Helper

        def initialize(mapper, id_or_ids_or_entity_or_entities)
          @mapper                          = mapper
          @id_or_ids_or_entity_or_entities = id_or_ids_or_entity_or_entities
        end

        def result
          ids = Array.wrap(@id_or_ids_or_entity_or_entities).map do |id_or_entity|
            @mapper.default_provider.build_criteria(
              :Destroy, @mapper.default_source_class, extract_entity_id(id_or_entity)
            )
          end
        end
      end
    end
  end
end
