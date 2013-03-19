require 'singleton'
require 'datamappify/repository/mapping_hash'
require 'datamappify/repository/dsl'
require 'datamappify/repository/attributes_mapper'

module Datamappify
  module Repository
    def self.included(klass)
      klass.class_eval do
        mattr_accessor :entity_class
        mattr_accessor :default_provider_class_name
        mattr_accessor :default_data_class_name
        mattr_accessor :custom_attributes_mapping
        mattr_accessor :data_mapping

        klass.custom_attributes_mapping = {}
        klass.data_mapping              = {}

        include Singleton
        extend DSL
      end
    end

    def initialize
      AttributesMapper.new(self).build_data_classes
      self
    end

    def find(id_or_ids)
      entities = Array.wrap(id_or_ids).map { |id| entity_class.new(:id => id) }

      data_mapping_walker do |provider_class_name, data_class_name, data_fields_mapping|
        persistence_class(provider_class_name).new(
          provider_class_name, entities, data_class_name
        ).find(data_fields_mapping)
      end

      id_or_ids.is_a?(Array) ? entities : entities[0]
    end

    def save(entity_or_entities)
      Array.wrap(entity_or_entities).each do |entity|
        create_or_update(entity)
      end

      entity_or_entities
    rescue Datamappify::Data::EntityInvalid
      false
    end

    def save!(entity_or_entities)
      save(entity_or_entities) || raise(Datamappify::Data::EntityNotSaved)
    end

    def destroy(id_ids_or_entity_entities)
      Array.wrap(id_ids_or_entity_entities).each do |id_or_entity|
        default_persistence.destroy(id_or_entity)
      end
    end

    def destroy!(id_ids_or_entity_entities)
      destroy(id_ids_or_entity_entities) || raise(Datamappify::Data::EntityNotDestroyed)
    end

    def method_missing(symbol, *args)
      default_persistence.send symbol, *args
    end

    private

    def default_persistence
      persistence_class(default_provider_class_name).new(
        default_provider_class_name, [], default_data_class_name
      )
    end

    def persistence_class(provider_class_name)
      "Datamappify::Data::#{provider_class_name}::Persistence".constantize
    end

    def create_or_update(entity)
      raise Datamappify::Data::EntityInvalid.new(entity) if entity.invalid?

      default_persistence.exists?(entity.id) ? update(entity) : create(entity)
    end

    def create(entity)
      data_mapping_walker do |provider_class_name, data_class_name, data_fields_mapping|
        persistence_class(provider_class_name).new(
          provider_class_name, [entity], data_class_name
        ).create(data_fields_mapping)
      end

      entity
    end

    def update(entity)
      data_mapping_walker do |provider_class_name, data_class_name, data_fields_mapping|
        persistence_class(provider_class_name).new(
          provider_class_name, [entity], data_class_name
        ).update(data_fields_mapping)
      end

      entity
    end

    def data_mapping_walker
      default_persistence.transaction do
        data_mapping.each do |provider_class_name, data_class_mapping|
          data_class_mapping.each do |data_class_name, data_fields_mapping|
            yield(provider_class_name, data_class_name, data_fields_mapping)
          end
        end
      end
    end
  end
end
