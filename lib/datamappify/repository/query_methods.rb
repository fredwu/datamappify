require 'datamappify/repository/query_method/method'

Dir[Datamappify.root.join('repository/query_method/*')].each { |file| require file }

module Datamappify
  module Repository
    module QueryMethods
      # @param id_or_ids [Integer, Array<Integer>]
      #   an entity id or a collection of entity ids
      #
      # @return [Entity, Array<Entity>, nil]
      def find(id_or_ids)
        QueryMethod::Find.new(options, id_or_ids).perform
      end

      # @param entity_or_entities [Entity, Array<Entity>]
      #   an entity or a collection of entities
      #
      # @return [Entity, Array<Entity>, false]
      def save(entity_or_entities)
        QueryMethod::Save.new(options, entity_or_entities).perform
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
        QueryMethod::Destroy.new(options, id_or_ids_or_entity_or_entities).perform
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
        QueryMethod::Count.new(options).perform
      end

      private

      # Some default, required objects passed into each query method
      #
      # @return [Hash]
      def options
        {
          :data_mapper => data_mapper,
          :states      => states
        }
      end
    end
  end
end
