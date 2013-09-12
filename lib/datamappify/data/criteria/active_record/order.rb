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

          private

          # @return [Array]
          def structured_criteria
            if super.values.first.is_a?(Hash)
              super.map do |table_prefix, values|
                values.map do |column, value|
                  "#{table_prefix}.#{column} #{value}"
                end
              end
            else
              super
            end
          end
        end
      end
    end
  end
end
