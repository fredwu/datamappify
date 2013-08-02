require 'datamappify/data/criteria/active_record/criteria_method'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Order < CriteriaMethod
          # @param scope [ActiveRecord::Relation]
          #
          # @return [ActiveRecord::Relation]
          def records(scope = nil)
            records_scope(scope).order(structured_criteria)
          end
        end
      end
    end
  end
end
