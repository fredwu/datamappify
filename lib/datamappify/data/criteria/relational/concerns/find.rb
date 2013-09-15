module Datamappify
  module Data
    module Criteria
      module Relational
        module Concerns
          module Find
            def perform
              record = records_scope.where(criteria).first

              update_entity_with(record) if record

              record
            end

            private

            def update_entity_with(record)
              attributes.each do |attribute|
                if attribute.secondary_attribute? || attribute.reverse_mapped?
                  update_entity_attribute_with(attribute, record.send(attribute.association_key))
                else
                  update_entity_attribute_with(attribute, record)
                end
              end
            end

            def update_entity_attribute_with(attribute, record)
              entity.send("#{attribute.name}=", record.send(attribute.source_attribute_name)) if record
            end
          end
        end
      end
    end
  end
end
