module Datamappify
  module Data
    module ActiveRecord
      class RecordMapper
        def initialize(entity, record)
          @entity = entity
          @record = record
        end

        def map_attributes(data_fields_mapping)
          @record.attributes.each do |name, value|
            return unless data_fields_mapping.has_key?(name.to_sym)

            @entity.send(:"#{data_fields_mapping[name.to_sym]}=", value)
          end
        end
      end
    end
  end
end
