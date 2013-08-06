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
            unless criteria_keys & attributes.map(&:key) == criteria_keys
              raise EntityAttributeInvalid
            end

            @updated_attributes ||= criteria.map do |attr_name, value|
              attribute = attributes.detect { |attr| attr.key == attr_name.to_sym }
              attribute.value = value
              attribute
            end
          end

          def criteria_keys
            criteria.keys.map(&:to_sym)
          end
        end
      end
    end
  end
end
