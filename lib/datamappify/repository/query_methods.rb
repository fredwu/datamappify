require 'datamappify/repository/query_method/method'

Dir[Datamappify.root.join('repository/query_method/*')].each { |file| require file }

module Datamappify
  module Repository
    module QueryMethods
      def self.included(klass)
        klass.class_eval do
          include QueryMethod::Callbacks
        end
      end

      # Does the entity exist already in the repository?
      #
      # @param entity [Entity]
      #
      # @return [Boolean]
      def exists?(entity)
        QueryMethod::Exists.new(query_options, entity).perform
      end

      # @param criteria [Integer, String]
      #   an entity id or a hash containing criteria
      #
      # @return [Entity, nil]
      def find(criteria)
        QueryMethod::Find.new(query_options, criteria).perform
      end

      # @param criteria [Hash]
      #   a hash containing criteria
      #
      # @return [Entity]
      def where(criteria)
        QueryMethod::FindMultiple.new(query_options, criteria).perform
      end

      # Returns a collection of all the entities in the repository
      #
      # @return [Array<Entity>]
      def all
        QueryMethod::FindMultiple.new(query_options, {}).perform
      end

      # @param entity [Entity]
      #   an entity or a collection of entities
      #
      # @return [Entity, false]
      def create(entity)
        run_callbacks entity, :save, :create do
          QueryMethod::Create.new(query_options, entity).perform
        end
      end

      # @param (see #create)
      #
      # @raise [Data::EntityNotSaved]
      #
      # @return [Entity]
      def create!(entity)
        create(entity) || raise(Data::EntityNotSaved)
      end

      # @param entity [Entity]
      #   an entity or a collection of entities
      #
      # @return [Entity, false]
      def update(entity)
        run_callbacks entity, :save, :update do
          QueryMethod::Update.new(query_options, entity).perform
        end
      end

      # @param (see #update)
      #
      # @raise [Data::EntityNotSaved]
      #
      # @return [Entity]
      def update!(entity)
        update(entity) || raise(Data::EntityNotSaved)
      end

      # @param entity [Entity]
      #   an entity or a collection of entities
      #
      # @return [Entity, false]
      def save(entity)
        exists?(entity) ? update(entity) : create(entity)
      end

      # @param (see #save)
      #
      # @raise [Data::EntityNotSaved]
      #
      # @return [Entity]
      def save!(entity)
        exists?(entity) ? update!(entity) : create!(entity)
      end

      # @param entity [Entity]
      #
      # @return [void, false]
      def destroy(entity)
        run_callbacks entity, :destroy do
          QueryMethod::Destroy.new(query_options, entity).perform
        end
      end

      # @param (see #destroy)
      #
      # @raise [Data::EntityNotDestroyed]
      #
      # @return [void]
      def destroy!(entity)
        destroy(entity) || raise(Data::EntityNotDestroyed)
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
