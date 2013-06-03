module Datamappify
  module Data
    module Criteria
      module Relational
        class FindMultiple < Common
          alias_method :entity_class, :entity

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

          # @return [void]
          def perform
            records.map do |record|
              entity = entity_class.new
              update_entity(entity, record)
              entity
            end
          end

          private

          # @return [Array]
          def updated_attributes
            @updated_attributes ||= attributes.select do |attribute|
              attribute.value = criteria[attribute.key]
              criteria.keys.include?(attribute.key)
            end
          end

          # @param entity [Entity]
          #
          # @param record [Class]
          #
          # @return [void]
          def update_entity(entity, primary_record)
            attributes.each do |attribute|
              record = data_record_for(attribute, primary_record)
              value  = record.nil? ? nil : record.send(attribute.source_attribute_name)

              entity.send("#{attribute.name}=", value)
            end
          end

          # @param attribute [Attribute]
          #
          # @param primary_record [Class]
          #   an ORM model object (ActiveRecord or Sequel, etc)
          #
          # @return [Class]
          #   an ORM model object (ActiveRecord or Sequel, etc)
          def data_record_for(attribute, primary_record)
            if attribute.primary_attribute?
              primary_record
            else
              primary_record.send(attribute.source_key)
            end
          end
        end
      end
    end
  end
end
