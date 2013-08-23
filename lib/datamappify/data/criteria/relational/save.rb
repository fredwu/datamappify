module Datamappify
  module Data
    module Criteria
      module Relational
        class Save < Common
          def perform
            update_criteria_for_existing_record

            new_record? ? create_record : save_record unless ignore?
          end

          private

          def create_record
            record = source_class.new(criteria)
            saved_record = save(record)

            update_entity_with(saved_record) if primary_record?

            record
          end

          def update_entity_with(record)
            entity.id = record.send(key_name)
          end

          def update_criteria_for_existing_record
            criteria[:id] = existing_pk_value if existing_pk_value
          end

          def existing_pk_value
            @existing_pk_value ||= options[:via].present? &&
              options[:primary_record].present? &&
              options[:primary_record].send(options[:via])
          end
        end
      end
    end
  end
end
