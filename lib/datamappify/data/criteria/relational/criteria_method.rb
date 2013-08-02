require 'datamappify/data/criteria/relational/criteria_base_method'

module Datamappify
  module Data
    module Criteria
      module Relational
        class CriteriaMethod < CriteriaBaseMethod
          attr_reader :primaries, :secondaries, :structured_criteria

          def initialize(*args)
            super

            @primaries   = []
            @secondaries = []

            updated_attributes.each do |attribute|
              collector = attribute.primary_attribute? ? @primaries : @secondaries
              collector << attribute
            end
          end

          private

          # @return [Array<Attribute>]
          def updated_attributes
            unless criteria.keys & attributes.map(&:key) == criteria.keys
              raise EntityAttributeInvalid
            end

            @updated_attributes ||= criteria.map do |attr_key, value|
              attribute = attributes.detect { |attr| attr.key == attr_key }
              attribute.value = value
              attribute
            end
          end
        end
      end
    end
  end
end
