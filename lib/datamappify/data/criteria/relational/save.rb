module Datamappify
  module Data
    module Criteria
      module Relational
        class Save < Common
          def perform
            new_record? ? create_record : save_record unless ignore?
          end

          private

          def create_record
            record = source_class.new(criteria)
            saved_record = save(record)

            update_entity_with(saved_record) if primary_record?
          end

          def update_entity_with(record)
            entity.id = record.send(key_name)
          end
        end
      end
    end
  end
end
