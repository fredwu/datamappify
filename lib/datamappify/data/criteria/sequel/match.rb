require 'datamappify/data/criteria/sequel/criteria_method'

module Datamappify
  module Data
    module Criteria
      module Sequel
        class Match < CriteriaMethod
          # @param scope [Sequel::DataSet]
          #
          # @return [Sequel::DataSet]
          def records(scope = nil)
            updated_attributes.inject(records_scope(scope)) do |scope, attr|
              scope.filter(
                ::Sequel.ilike(:"#{attr.source_table}__#{attr.source_attribute_key}", attr.value)
              )
            end
          end
        end
      end
    end
  end
end
