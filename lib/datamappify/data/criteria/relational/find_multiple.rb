module Datamappify
  module Data
    module Criteria
      module Relational
        class FindMultiple < Common
          alias_method :entity_class, :entity

          def perform
            records = source_class.where(criteria)
            records.map do |record|
              entity = entity_class.new
              update_entity(entity, record)
              entity
            end
          end

          private

          def update_entity(entity, record)
            attributes.each do |attribute|
              entity.send("#{attribute.name}=", record.send(attribute.source_attribute_name))
            end
          end
        end
      end
    end
  end
end
