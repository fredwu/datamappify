require 'datamappify/data/criteria/active_record/criteria_method'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Order < CriteriaMethod
          def initialize(*args)
            super

            validate_order_args
          end

          # @param scope [ActiveRecord::Relation]
          #
          # @return [ActiveRecord::Relation]
          def records(scope = nil)
            structured_criteria.inject(records_scope(scope)) do |scope, (table, values)|
              if values.is_a?(Hash)
                values.inject(scope) do |s, (column, value)|
                  s.order("#{table}.#{column} #{value}")
                end
              else
                scope.order(table => values)
              end
            end
          end

          private

          # @return [void]
          def validate_order_args
            unless (criteria.values - [:asc, :desc]).empty?
              raise ArgumentError.new('Order direction should be :asc or :desc')
            end
          end
        end
      end
    end
  end
end
