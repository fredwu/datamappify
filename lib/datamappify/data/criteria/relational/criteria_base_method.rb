module Datamappify
  module Data
    module Criteria
      module Relational
        class CriteriaBaseMethod < Common
          alias_method :entity_class, :entity

          # @return [void]
          def perform
            records.map do |record|
              entity = entity_class.new
              update_entity(entity, record)
              entity
            end
          end

          private

          # @param entity [Entity]
          #
          # @param record [Class]
          #
          # @return [void]
          def update_entity(entity, primary_record)
            attributes.each do |attribute|
              record = data_record_for(attribute, primary_record)
              value  = record_value_for(attribute, record)

              entity.send("#{attribute.name}=", value)
            end
          end

          # @param attribute [Attribute]
          #
          # @param primary_record [Class]
          #   an ORM model object (ActiveRecord or Sequel, etc)
          #
          # @return [Object]
          #   an ORM model object (ActiveRecord or Sequel, etc)
          def data_record_for(attribute, primary_record)
            if attribute.primary_attribute?
              primary_record
            else
              primary_record.send(attribute.association_key)
            end
          end

          # @param attribute [Attribute]
          #
          # @param record [Class]
          #   an ORM model object (ActiveRecord or Sequel, etc)
          #
          # @return [any]
          def record_value_for(attribute, record)
            record.nil? ? nil : record.send(attribute.source_attribute_name)
          end
        end
      end
    end
  end
end
