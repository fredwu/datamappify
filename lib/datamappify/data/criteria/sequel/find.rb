module Datamappify
  module Data
    module Criteria
      module Sequel
        class Find < Common
          def result
            record = source_class.where(criteria).first

            update_entity_with(record) if record
          end

          private

          def update_entity_with(record)
            attributes.each do |attribute|
              entity.send("#{attribute.name}=", record.send(attribute.source_attribute_name))
            end
          end
        end
      end
    end
  end
end
