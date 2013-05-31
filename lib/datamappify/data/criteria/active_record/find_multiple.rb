require 'datamappify/data/criteria/relational/find_multiple'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class FindMultiple < Relational::FindMultiple
          private

          # @return [Array]
          def records
            source_class.joins(@secondaries.map(&:source_key)).where(
              structured_criteria(primaries, secondaries)
            )
          end

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
              _criteria[secondary.source_table] ||= {}
              _criteria[secondary.source_table][secondary.source_attribute_key] = secondary.value
            end

            _criteria
          end

          # @param entity [Entity]
          #
          # @param record [Class]
          #
          # @return [void]
          def update_entity(entity, record)
            updated_attributes.each do |attribute|
              unless attribute.primary_attribute?
                record = record.send(attribute.source_key)
              end

              entity.send("#{attribute.name}=", record.send(attribute.source_attribute_name))
            end
          end
        end
      end
    end
  end
end
