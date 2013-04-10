module Datamappify
  module Data
    module Criteria
      module Sequel
        class Save < Relational::Save
          private

          def update
            record = source_class.find(criteria) || source_class.new(criteria)
            save(record)
          end

          def save(record)
            record.update attributes_and_values
            record
          end
        end
      end
    end
  end
end
