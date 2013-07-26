require 'datamappify/data/criteria/sequel/where'
require 'datamappify/data/criteria/sequel/limit'

module Datamappify
  module Data
    module Criteria
      module Sequel
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
