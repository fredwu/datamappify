require 'datamappify/data/provider/active_record/record/mapper'
require 'datamappify/data/provider/active_record/record/writer'

module Datamappify
  module Data
    module ActiveRecord
      class Persistence < Data::Persistence
        def find(data_fields_mapping)
          records = find_records(data_fields_mapping)

          entities_walker do |entity|
            if record = find_record_for_entity(entity, records)
              RecordMapper.new(entity, record).map_attributes(data_fields_mapping)
            end
          end
        end

        def create(data_fields_mapping)
          entities_walker do |entity|
            if has_data_to_insert?(entity, data_fields_mapping)
              RecordWriter.new(entity, data_class, key_field_name).insert_record(data_fields_mapping)
            end
          end
        end

        def update(data_fields_mapping)
          records = find_records(data_fields_mapping)

          entities_walker do |entity|
            record_writer = RecordWriter.new(entity, data_class, key_field_name)

            if record = find_record_for_entity(entity, records)
              record_writer.update_record(record, data_fields_mapping)
            elsif has_data_to_insert?(entity, data_fields_mapping)
              record_writer.insert_record(data_fields_mapping)
            end
          end
        end

        def destroy(id_or_entity)
          data_class.destroy(Util.extract_entity_id(id_or_entity))
        end

        def exists?(id)
          data_class.exists?(id)
        end

        def transaction(&block)
          data_class.transaction(&block)
        end

        private

        def entities_walker
          walker_method = is_entity_class? ? :keep_if : :each

          @entities.send(walker_method) do |entity|
            yield(entity)
          end
        end

        def find_records(data_fields_mapping)
          data_class.select(
            data_fields_mapping.field_names << key_field_name << :id
          ).where(
            key_field_name => @entities.map(&:id)
          )
        end

        def find_record_for_entity(entity, records)
          records.find { |r| r.send(key_field_name) == entity.id }
        end

        def has_data_to_insert?(entity, data_fields_mapping)
          attribute_names = entity.attributes.keys & data_fields_mapping.attribute_names

          attribute_names.any? && Util.attributes_filtered_by(entity, attribute_names).values.compact.any?
        end
      end
    end
  end
end
