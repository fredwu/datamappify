require 'datamappify/repository/query_method/method'

Dir[Datamappify.root.join('repository/query_method/*')].each { |file| require file }

module Datamappify
  module Repository
    module QueryMethods
      # @param id [Integer]
      #   an entity id or a collection of entity ids
      #
      # @return [Entity, nil]
      def find(id)
        QueryMethod::Find.new(query_options, id).perform
      end

      # @param entity [Entity]
      #   an entity or a collection of entities
      #
      # @return [Entity, false]
      def save(entity)
        QueryMethod::Save.new(query_options, entity).perform
      end

      # @param (see #save)
      #
      # @raise [Data::EntityNotSaved]
      #
      # @return [Entity]
      def save!(entity)
        save(entity) || raise(Data::EntityNotSaved)
      end

      # @param id_or_entity [Entity]
      #   an entity or a collection of ids or entities
      #
      # @return [void, false]
      def destroy(id_or_entity)
        QueryMethod::Destroy.new(query_options, id_or_entity).perform
      end

      # @param (see #destroy)
      #
      # @raise [Data::EntityNotDestroyed]
      #
      # @return [void]
      def destroy!(id_or_entity)
        destroy(id_or_entity) || raise(Data::EntityNotDestroyed)
      end

      # @return [Integer]
      def count
        QueryMethod::Count.new(query_options).perform
      end

      private

      # Some default, required objects passed into each query method
      #
      # @return [Hash]
      def query_options
        {
          :data_mapper => data_mapper,
          :states      => states,
          :lazy_load?  => lazy_load?
        }
      end
    end
  end
end
