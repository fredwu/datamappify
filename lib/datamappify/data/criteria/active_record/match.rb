require 'datamappify/data/criteria/active_record/criteria_method'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Match < CriteriaMethod
          # @param scope [ActiveRecord::Relation]
          #
          # @return [ActiveRecord::Relation]
          def records(scope = nil)
            updated_attributes.inject(records_scope(scope)) do |scope, attr|
              scope.where(
                attr.source_class.all.table[attr.source_attribute_key].matches(attr.value)
              )
            end
          end
        end
      end
    end
  end
end
