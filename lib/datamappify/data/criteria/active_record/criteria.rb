require 'datamappify/data/criteria/active_record/where'
require 'datamappify/data/criteria/active_record/limit'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Criteria < Relational::Criteria
          private

          def criteria_classes
            {
              :where => Where,
              :limit => Limit,
            }
          end
        end
      end
    end
  end
end
