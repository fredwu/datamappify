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
        run_callbacks entity, :load, :find do
          QueryMethod::Exists.new(query_options, entity).perform
        end
      end

      # @param criteria [Integer, String]
      #   an entity id or a hash containing criteria
      #
      # @return [Entity, nil]
      def find(criteria)
        run_callbacks criteria, :load, :find do
          QueryMethod::Find.new(query_options, criteria).perform
        end
      end

      # @param criteria [Hash]
      #   a hash containing criteria
      #
      # @return [Entity]
      def where(criteria)
        QueryMethod::Where.new(query_options, criteria).perform.map do |entity|
          run_callbacks(entity, :load, :find) { entity }
        end
      end

      # @param criteria [Hash]
      #   a hash containing criteria
      #
      # @return [Entity]
      def match(criteria)
        QueryMethod::Match.new(query_options, criteria).perform.map do |entity|
          run_callbacks(entity, :load, :find) { entity }
        end
      end

      # Returns a collection of all the entities in the repository
      #
      # @return [Array<Entity>]
      def all
        QueryMethod::Where.new(query_options, {}).perform.map do |entity|
          run_callbacks(entity, :load, :find) { entity }
        end
      end

      # @param criteria [Hash]
      #   a hash containing composed criteria
      #
      # @return [Array<Entity>]
      def criteria(criteria)
        QueryMethod::Criteria.new(query_options, criteria).perform.map do |entity|
          run_callbacks(entity, :load, :find) { entity }
        end
      end

      # @param entity [Entity]
      #   an entity or a collection of entities
      #
      # @return [Entity, false]
      def create(entity)
        run_callbacks entity, :load, :save, :create do
          QueryMethod::Create.new(query_options, entity).perform
        end
      end

      # @param (see #create)
      #
      # @raise [Data::EntityNotSaved]
      #
      # @return [Entity]
      def create!(entity)
        create(entity) || raise(Data::EntityNotSaved.new(entity.errors))
      end

      # @param entity [Entity]
      #   an entity or a collection of entities
      #
      # @return [Entity, false]
      def update(entity)
        run_callbacks entity, :load, :save, :update do
          QueryMethod::Update.new(query_options, entity).perform
        end
      end

      # @param (see #update)
      #
      # @raise [Data::EntityNotSaved]
      #
      # @return [Entity]
      def update!(entity)
        update(entity) || raise(Data::EntityNotSaved.new(entity.errors))
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
        run_callbacks entity, :load, :destroy do
          QueryMethod::Destroy.new(query_options, entity).perform
        end
      end

      # @param (see #destroy)
      #
      # @raise [Data::EntityNotDestroyed]
      #
      # @return [void]
      def destroy!(entity)
        destroy(entity) || raise(Data::EntityNotDestroyed.new(entity.errors))
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
