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
            records_scope(scope).order(string_criteria)
          end

          private

          # @return [void]
          def validate_order_args
            unless (criteria.values - [:asc, :desc]).empty?
              raise ArgumentError.new('Order direction should be :asc or :desc')
            end
          end

          # @return [Array]
          def string_criteria
            structured_criteria.map do |table, values|
              if values.is_a?(Hash)
                values.map do |column, value|
                  "#{table}.#{column} #{value}"
                end
              else
                "#{table} #{values}"
              end
            end.join(', ')
          end
        end
      end
    end
  end
end
