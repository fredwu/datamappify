require 'datamappify/repository/mapping_dsl'
require 'datamappify/repository/query_method'
require 'datamappify/data'

module Datamappify
  module Repository
    def self.included(klass)
      klass.class_eval do
        include Singleton
        extend  SingletonWrapper

        cattr_accessor :data_mapper

        self.data_mapper = Data::Mapper.new

        extend  MappingDSL
        include InstanceMethods
      end
    end

    module InstanceMethods
      # @param id_or_ids [Integer, Array<Integer>]
      #   an entity id or a collection of entity ids
      #
      # @return [Entity, Array<Entity>, nil]
      def find(id_or_ids)
        QueryMethod::Find.new(data_mapper, id_or_ids).result
      end

      # @param entity_or_entities [Entity, Array<Entity>]
      #   an entity or a collection of entities
      #
      # @return [Entity, Array<Entity>, false]
      def save(entity_or_entities)
        QueryMethod::Save.new(data_mapper, entity_or_entities).result
      end

      # @param (see #save)
      #
      # @raise [Data::EntityNotSaved]
      #
      # @return [Entity, Array<Entity>]
      def save!(entity_or_entities)
        save(entity_or_entities) || raise(Data::EntityNotSaved)
      end

      # @param id_or_ids_or_entity_or_entities [Entity, Array<Entity>]
      #   an entity or a collection of ids or entities
      #
      # @return [void, false]
      def destroy(id_or_ids_or_entity_or_entities)
        QueryMethod::Destroy.new(data_mapper, id_or_ids_or_entity_or_entities).result
      end

      # @param (see #destroy)
      #
      # @raise [Data::EntityNotDestroyed]
      #
      # @return [void]
      def destroy!(id_or_ids_or_entity_or_entities)
        destroy(id_or_ids_or_entity_or_entities) || raise(Data::EntityNotDestroyed)
      end

      # @return [Integer]
      def count
        QueryMethod::Count.new(data_mapper).result
      end
    end

    # Wraps a ruby Singleton class so that calling `instance` is no longer necessary.
    #
    # @example With `instance`
    #   UserRepository.instance.count
    #
    # @example Without `instance`
    #   UserRepository.count
    module SingletonWrapper
      def self.extended(klass)
        class << klass
          extend Forwardable
          def_delegators :instance, *InstanceMethods.instance_methods
        end
      end
    end
  end
end
