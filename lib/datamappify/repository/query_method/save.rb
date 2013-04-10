module Datamappify
  module Repository
    module QueryMethod
      class Save
        def initialize(mapper, entity_or_entities)
          @mapper             = mapper
          @entity_or_entities = entity_or_entities
          @helper             = Helper.new(@mapper)
        end

        def result
          Array.wrap(@entity_or_entities).each do |entity|
            create_or_update(entity)
          end

          @entity_or_entities
        rescue Datamappify::Data::EntityInvalid
          false
        end

        private

        def create_or_update(entity)
          raise Datamappify::Data::EntityInvalid.new(entity) if entity.invalid?

          dispatch_criteria_to_providers(entity)

          entity
        end

        def dispatch_criteria_to_providers(entity)
          @helper.attributes_walker do |provider_name, source_class, attributes|
            @mapper.provider(provider_name).build_criteria(
              :SaveByKey, source_class, entity, attributes
            )
          end
        end
      end
    end
  end
end
