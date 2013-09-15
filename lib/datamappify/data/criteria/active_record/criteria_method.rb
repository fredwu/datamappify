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
          def records_scope(scope = nil)
            (scope || source_class).includes(associated.map(&:association_key))
                                   .references(associated.map(&:association_key))
          end

          # @return [Array<Attribute>]
          def associated
            attributes.select(&:secondary_attribute?)
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
              table_alias = detect_table_alias(secondary)

              _criteria[table_alias] ||= {}
              _criteria[table_alias][secondary.source_attribute_key] = secondary.value
            end

            _criteria
          end

          # @see https://github.com/rails/rails/issues/12224
          #
          # @param [Attribute]
          #
          # @return [Symbol]
          def detect_table_alias(attribute)
            reflection = records_scope.send(:construct_join_dependency_for_association_find).join_parts.detect do |join|
              join.try(:reflection).try(:name) == attribute.association_key
            end

            if reflection
              reflection.tables[0].try(:right) || attribute.source_table
            else
              attribute.source_table
            end
          end
        end
      end
    end
  end
end
