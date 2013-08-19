require 'datamappify/data/criteria/concerns/update_primary_record'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Save < Relational::Save
          prepend Concerns::UpdatePrimaryRecord

          private

          def save_record
            record = source_class.where(criteria).first_or_initialize
            save(record)
          end

          def save(record)
            record.update_attributes attributes_and_values
          end
        end
      end
    end
  end
end
