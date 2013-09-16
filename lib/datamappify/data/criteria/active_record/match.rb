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
            records_scope(scope).where(string_criteria, *criteria.values)
          end

          private

          # @return [String]
          def string_criteria
            structured_criteria.map do |column, value|
              "#{column} LIKE ?"
            end.join(' AND ')
          end

          # @return [Hash]
          def structured_criteria
            Hash[*super.flat_map do |table, values|
              if values.is_a?(Hash)
                values.flat_map do |column, value|
                  ["#{table}.#{column}", value]
                end
              else
                ["#{records_scope.table.name}.#{table}", values]
              end
            end]
          end
        end
      end
    end
  end
end
