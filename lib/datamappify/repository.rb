require 'datamappify/repository/helper'
require 'datamappify/repository/mapping_dsl'
require 'datamappify/repository/query_method'
require 'datamappify/data'

module Datamappify
  module Repository
    def self.included(klass)
      klass.class_eval do
        include Singleton

        cattr_accessor :data_mapper

        self.data_mapper = Data::Mapper.new

        extend MappingDSL
      end
    end

    def find(id_or_ids)
      QueryMethod::Find.new(data_mapper, id_or_ids).result
    end

    def save(entity_or_entities)
      QueryMethod::Save.new(data_mapper, entity_or_entities).result
    end

    def save!(entity_or_entities)
      save(entity_or_entities) || raise(Datamappify::Data::EntityNotSaved)
    end

    def destroy(id_or_ids_or_entity_or_entities)
      QueryMethod::Destroy.new(data_mapper, id_or_ids_or_entity_or_entities).result
    end

    def destroy!(id_or_ids_or_entity_or_entities)
      destroy(id_or_ids_or_entity_or_entities) || raise(Datamappify::Data::EntityNotDestroyed)
    end

    def count
      QueryMethod::Count.new(data_mapper).result
    end
  end
end
