require 'datamappify/data/criteria/relational/criteria_method'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class CriteriaMethod < Relational::CriteriaMethod
          private

          # @param scope [ActiveRecord::Relation]
          #
          # @return [ActiveRecord::Relation]
          def records_scope(scope)
            (scope || source_class).joins(secondaries.map(&:association_key))
          end

          # @param primaries [Array<Attribute>]
          #
          # @param secondaries [Array<Attribute>]
          #
          # @return [Hash]
          def structured_criteria
            _criteria = {}

            primaries.each do |primary|
              _criteria[primary.source_attribute_key] = primary.value
            end

            secondaries.each do |secondary|
              _criteria[secondary.source_table] ||= {}
              _criteria[secondary.source_table][secondary.source_attribute_key] = secondary.value
            end

            _criteria
          end
        end
      end
    end
  end
end
