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
            order_conditions = structured_criteria.map do |table_column, value|
              ::Sequel.send(value, table_column)
            end

            records_scope(scope).order(*order_conditions)
          end
        end
      end
    end
  end
end
