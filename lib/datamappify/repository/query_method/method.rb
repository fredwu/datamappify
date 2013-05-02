require 'datamappify/repository/query_method/method/source_attributes_walker'

module Datamappify
  module Repository
    module QueryMethod
      # Provides a default set of methods to the varies {QueryMethod} classes
      class Method
        # @return [Data::Mapper]
        attr_reader :data_mapper

        # @return [UnitOfWork::PersistentStates]
        attr_reader :states

        # @param options [Hash]
        #   a hash containing required items like data_mapper and states
        #
        # @param args [any]
        def initialize(options, *args)
          @data_mapper = options[:data_mapper]
          @states      = options[:states]
        end

        # Should the method be aware of the dirty state?
        # i.e. {Find} probably doesn't whereas {Save} does
        #
        # Override this method for individual query methods
        #
        # @return [Boolean]
        def dirty_aware?
          false
        end

        protected

        # Dispatches a {Criteria} according to
        # the {Data::Mapper data mapper}'s default provider and default source class
        #
        # @param criteria_name [Symbol]
        #
        # @param args [any]
        def dispatch_criteria_to_default_source(criteria_name, *args)
          data_mapper.default_provider.build_criteria(
            criteria_name, data_mapper.default_source_class, *args
          )
        end

        # Dispatches a {Criteria} via {#attributes_walker}
        #
        # @param criteria_name [Symbol]
        #
        # @param entity [Entity]
        #
        # @return [void]
        def dispatch_criteria_to_providers(criteria_name, entity)
          attributes_walker(entity) do |provider_name, source_class, attributes|
            data_mapper.provider(provider_name).build_criteria(
              criteria_name, source_class, entity, attributes
            )
          end
        end

        # Walks through the attributes and performs actions on them
        #
        # @param entity [Entity]
        #
        # @yield (see SourceAttributesWalker#execute)
        #
        # @yieldparam (see SourceAttributesWalker#execute)
        #
        # @return [void]
        #
        # @see SourceAttributesWalker#execute
        def attributes_walker(entity, &block)
          UnitOfWork::Transaction.new(data_mapper) do
            data_mapper.classified_attributes.each do |provider_name, attributes|
              SourceAttributesWalker.new({
                :entity        => entity,
                :provider_name => provider_name,
                :attributes    => attributes,
                :query_method  => self
              }).execute(&block)
            end
          end
        end

        # Extract the id out of an entity, unless the argument is already an id
        #
        # @param id_or_entity [Entity, Integer]
        #
        # @return [Integer]
        def extract_entity_id(id_or_entity)
          id_or_entity.is_a?(Integer) ? id_or_entity : id_or_entity.id
        end

        class << self
          private

          # A meta method to help record whether a criteria has been performed,
          # it is useful for testing the action(s) of dirty attributes
          #
          # @return [TrueClass]
          def performed
            true
          end
        end
      end
    end
  end
end
