require 'datamappify/data/provider/common/persistence'

module Datamappify
  module Data
    module Provider
      module Common
        module Relational
          class Persistence < Data::Provider::Common::Persistence
            def find(data_fields_mapping)
              records = find_records(data_fields_mapping)

              entities_walker do |entity|
                if record = find_record_for_entity(entity, records)
                  Common::Relational::RecordMapper.new(
                    entity, record.send(record_attributes_method)
                  ).map_attributes(data_fields_mapping)
                end
              end
            end

            def create(data_fields_mapping)
              entities_walker do |entity|
                if has_data_to_insert?(entity, data_fields_mapping)
                  Common::Relational::RecordWriter.new(
                    entity, data_class, key_field_name
                  ).insert_record(data_fields_mapping)
                end
              end
            end

            def update(data_fields_mapping)
              records = find_records(data_fields_mapping)

              entities_walker do |entity|
                record_writer = Common::Relational::RecordWriter.new(entity, data_class, key_field_name)

                if record = find_record_for_entity(entity, records)
                  record_writer.update_record(record, data_fields_mapping)
                elsif has_data_to_insert?(entity, data_fields_mapping)
                  record_writer.insert_record(data_fields_mapping)
                end
              end
            end

            private

            def find_record_for_entity(entity, records)
              records.find { |r| r.send(key_field_name) == entity.id }
            end

            def find_records(data_fields_mapping)
              data_class.select(
                *field_names(data_fields_mapping)
              ).where(
                key_field_name => @entities.map(&:id)
              )
            end

            def entities_walker
              walker_method = is_entity_class? ? :keep_if : :each

              @entities.send(walker_method) do |entity|
                yield(entity)
              end
            end

            def key_field_name
              is_entity_class? ? :id : "#{entity_class_name.underscore}_id".to_sym
            end

            def field_names(data_fields_mapping)
              (data_fields_mapping.field_names << key_field_name << :id).uniq
            end

            def has_data_to_insert?(entity, data_fields_mapping)
              attribute_names = entity.attributes.keys & data_fields_mapping.attribute_names

              attribute_names.any? && Util.attributes_filtered_by(entity, attribute_names).values.compact.any?
            end
          end
        end
      end
    end
  end
end
