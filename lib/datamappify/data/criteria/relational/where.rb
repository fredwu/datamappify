require 'datamappify/data/criteria/relational/criteria_method'

module Datamappify
  module Data
    module Criteria
      module Relational
        class Where < CriteriaMethod
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

          # @return [Array]
          def updated_attributes
            unless criteria.keys & attributes.map(&:key) == criteria.keys
              raise EntityAttributeInvalid
            end

            @updated_attributes ||= attributes.select do |attribute|
              attribute.value = criteria[attribute.key]
              criteria.keys.include?(attribute.key)
            end
          end
        end
      end
    end
  end
end
