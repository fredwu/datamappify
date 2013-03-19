module Datamappify
  module Data
    module ActiveRecord
      class RecordWriter
        def initialize(entity, data_class, key_field_name)
          @entity         = entity
          @data_class     = data_class
          @key_field_name = key_field_name
        end

        def insert_record(data_fields_mapping)
          if is_foreign_record?
            insert_foreign_record(data_fields_mapping)
          else
            new_record = insert_primary_record(data_fields_mapping)
            update_entity_with_new_record_id(new_record.id)
          end
        end

        def update_record(record, data_fields_mapping)
          update_record_with_fields(record, data_fields_mapping)
        end

        private

        def is_foreign_record?
          @key_field_name != :id
        end

        def insert_foreign_record(data_fields_mapping)
          new_record = @data_class.new
          new_record.send "#{@key_field_name}=", @entity.id
          update_record_with_fields(new_record, data_fields_mapping)
        end

        def insert_primary_record(data_fields_mapping)
          update_record_with_fields(@data_class.new, data_fields_mapping)
        end

        def update_record_with_fields(record, data_fields_mapping)
          data_fields_mapping.field_names.each do |field_name|
            attribute_name = data_fields_mapping[field_name]
            record.send "#{field_name}=", @entity.attributes[attribute_name]
          end

          record.save!
          record
        end

        def update_entity_with_new_record_id(id)
          @entity.id = id
        end
      end
    end
  end
end
