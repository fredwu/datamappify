require 'datamappify/data/criteria/relational/save'
require 'datamappify/data/criteria/concerns/update_primary_record'

module Datamappify
  module Data
    module Criteria
      module Sequel
        class Save < Relational::Save
          include Concerns::UpdatePrimaryRecord

          private

          def save_record
            record = source_class.find(criteria) || source_class.new(criteria)
            save(record)
          end

          def save(record)
            record.update attributes_and_values

            super
          end
        end
      end
    end
  end
end
