require 'datamappify/data/criteria/sequel/criteria_method'

module Datamappify
  module Data
    module Criteria
      module Sequel
        class Order < CriteriaMethod
          # @param scope [Sequel::DataSet]
          #
          # @return [Sequel::DataSet]
          def records(scope = nil)
            structured_criteria.inject(records_scope(scope)) do |scope, (attr, value)|
              case value
              when :asc  then scope.order(attr)
              when :desc then scope.reverse_order(attr)
              end
            end
          end
        end
      end
    end
  end
end
