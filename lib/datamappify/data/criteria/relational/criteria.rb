require 'datamappify/data/criteria/relational/criteria_method'

module Datamappify
  module Data
    module Criteria
      module Relational
        class Criteria < CriteriaMethod
          # @return
          #   a collection represents the records, e.g. `ActiveRecord::Relation` or `Sequel::DataSet`
          def records
            criteria.inject(nil) do |scope, (name, method_criteria)|
              criteria_class(name).new(
                source_class, entity, method_criteria, attributes, options
              ).records(scope)
            end
          end

          private

          # @return [Class]
          #   the criteria class, e.g. `Where` or `Limit`
          def criteria_class(name)
            self.class.name.deconstantize.constantize.const_get(name.to_s.classify)
          end
        end
      end
    end
  end
end
