Dir[Datamappify.root.join('repository/query_method/method/*')].each { |file| require file }

module Datamappify
  module Repository
    module QueryMethod
      # Provides a default set of methods to the varies {QueryMethod} classes
      class Method
        # @return [Data::Mapper]
        attr_reader :data_mapper

        # @return [UnitOfWork::PersistentStates]
        attr_reader :states

        # @return [Entity, Hash, nil]
        attr_reader :entity

        # @return [Entity, Hash, nil]
        attr_reader :criteria

        # @param options [Hash]
        #   a hash containing required items like data_mapper and states
        #
        # @param entity_or_criteria [Entity, Hash]
        #
        # @param args [any]
        def initialize(options, entity_or_criteria = nil, *args)
          @data_mapper = options[:data_mapper]
          @states      = options[:states]
          @lazy_load   = options[:lazy_load?]

          @entity = @criteria = entity_or_criteria
        end

        # Should the method be aware of the dirty state?
        # i.e. {Find} probably doesn't whereas {Save} does
        #
        # @note Override this method for individual query methods
        #
        # @return [Boolean]
        def dirty_aware?
          false
        end

        # The method is for reading data?
        #
        # @note Override this method for individual query methods
        #
        # @return [Boolean]
        def reader?
          false
        end

        # The method is for writing data?
        #
        # @note Override this method for individual query methods
        #
        # @return [Boolean]
        def writer?
          false
        end

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
          _primary_record = nil

          attributes_walker(entity) do |provider_name, source_class, attributes|
            attributes.classify { |attr| attr.options[:via] }.each do |via, attrs|
              record = data_mapper.provider(provider_name).build_criteria(
                criteria_name,
                source_class,
                entity,
                attrs,
                :via            => via,
                :primary_record => _primary_record
              )

              _primary_record ||= record
            end
          end

          references_walker(criteria_name, entity)
        end

        private

        # Walks through the attributes and performs actions on them
        #
        # @param entity [Entity]
        #
        # @yield (see SourceAttributesWalker#execute)
        #
        # @yieldparam (see SourceAttributesWalker#execute)
        #
        # @yieldreturn (see SourceAttributesWalker#execute)
        #
        # @return [void]
        #
        # @see SourceAttributesWalker#execute
        def attributes_walker(entity, &block)
          UnitOfWork::Transaction.new(data_mapper) do
            data_mapper.classified_attributes.each do |provider_name, attributes|
              source_attributes_walker.new({
                :entity           => entity,
                :provider_name    => provider_name,
                :attributes       => attributes,
                :dirty_aware?     => dirty_aware?,
                :dirty_attributes => states.find(entity).changed,
                :query_method     => self
              }).execute(&block)
            end
          end
        end

        # Walks through the references and performs actions on them
        #
        # @param (see #dispatch_criteria_to_providers)
        def references_walker(criteria_name, entity)
          data_mapper.references.each do |reference_name, options|
            ReferenceHandler.new({
              :entity            => entity,
              :criteria_name     => criteria_name,
              :reference_name    => reference_name,
              :reference_options => options,
              :query_method      => self
            }).execute
          end
        end

        # return [Class]
        def source_attributes_walker
          if @lazy_load
            Lazy::SourceAttributesWalker
          else
            SourceAttributesWalker
          end
        end
      end
    end
  end
end
