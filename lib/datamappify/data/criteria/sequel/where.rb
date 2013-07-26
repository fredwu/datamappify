module Datamappify
  module Data
    module Criteria
      module Sequel
        class Where < Relational::Where
          # @param scope [Sequel::DataSet]
          #
          # @return [Sequel::DataSet]
          def records(scope = nil)
            if scope
              query_builder = scope
            else
              query_builder = source_class

              secondaries.each do |secondary|
                query_builder = query_builder.join(secondary.source_table, secondary.primary_reference_key => :id)
              end
            end

            query_builder.where(structured_criteria(primaries, secondaries))
          end

          private

          # @param primaries [Array<Attribute>]
          #
          # @param secondaries [Array<Attribute>]
          #
          # @return [Hash]
          def structured_criteria(primaries, secondaries)
            _criteria = {}

            primaries.each do |primary|
              _criteria[primary.source_attribute_key] = primary.value
            end

            secondaries.each do |secondary|
              _criteria[:"#{secondary.source_table}__#{secondary.source_attribute_name}"] = secondary.value
            end

            _criteria
          end
        end
      end
    end
  end
end
