module Datamappify
  module Repository
    module QueryMethod
      class Save
        def initialize(mapper, entity_or_entities)
          @mapper             = mapper
          @entity_or_entities = entity_or_entities
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
          attributes_walker do |provider_name, source_class, attributes|
            @mapper.provider(provider_name).build_criteria(
              :SaveByKey, source_class, entity, attributes
            )
          end
        end

        def attributes_walker(&block)
          Transaction.new(@mapper) do
            @mapper.classified_attributes.each do |provider_name, attributes|
              attributes.classify(&:source_class).each do |source_class, attrs|
                block.call(provider_name, source_class, attrs)
              end
            end
          end
        end
      end
    end
  end
end
