require 'datamappify/data/criteria/concerns/update_primary_record'

module Datamappify
  module Data
    module Criteria
      module Sequel
        class Save < Relational::Save
          prepend Concerns::UpdatePrimaryRecord

          private

          def save_record
            record = source_class.find(criteria) || source_class.new(criteria)
            save(record)
          end

          def save(record)
            sanitise_attributes!(record)

            record.update(attributes_and_values) unless ignore?
          end

          def sanitise_attributes!(record)
            attributes_and_values.delete_if { |_, v| v.nil? } if record.new?
          end
        end
      end
    end
  end
end
