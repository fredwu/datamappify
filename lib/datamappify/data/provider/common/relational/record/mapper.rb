module Datamappify
  module Data
    module Provider
      module Common
        module Relational
          class RecordMapper
            def initialize(entity, record_attributes)
              @entity            = entity
              @record_attributes = record_attributes
            end

            def map_attributes(data_fields_mapping)
              @record_attributes.each do |name, value|
                return unless data_fields_mapping.has_key?(name.to_sym)

                @entity.send(:"#{data_fields_mapping[name.to_sym]}=", value)
              end
            end
          end
        end
      end
    end
  end
end
