module Datamappify
  module Repository
    module QueryMethod
      # Provides a default set of methods to the varies {QueryMethod} classes
      class Method
        # @param mapper [Data::Mapper]
        #
        # @param args [any]
        def initialize(mapper, *args)
          @mapper = mapper
        end

        protected

        # Dispatches a {Criteria} according to
        # the {Data::Mapper data mapper}'s default provider and default source class
        #
        # @param criteria_name [Symbol]
        #
        # @param args [any]
        def dispatch_criteria_to_default_source(criteria_name, *args)
          @mapper.default_provider.build_criteria(criteria_name, @mapper.default_source_class, *args)
        end

        # Dispatches a {Criteria} via {#attributes_walker}
        #
        # @param criteria_name [Symbol]
        #
        # @param entity [Entity]
        #
        # @return [void]
        def dispatch_criteria_to_providers(criteria_name, entity)
          attributes_walker do |provider_name, source_class, attributes|
            @mapper.provider(provider_name).build_criteria(
              criteria_name, source_class, entity, attributes
            )
          end
        end

        # Walks through the attributes and performs actions on them
        #
        # @yield [provider_name, source_class, attributes]
        #   action to be performed on the attributes grouped by their source class
        #
        # @yieldparam provider_name [String]
        #
        # @yieldparam source_class [Class]
        #
        # @yieldparam attributes [Set]
        #
        # @return [void]
        def attributes_walker(&block)
          Transaction.new(@mapper) do
            @mapper.classified_attributes.each do |provider_name, attributes|
              attributes.classify(&:source_class).each do |source_class, attrs|
                block.call(provider_name, source_class, attrs)
              end
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
      end
    end
  end
end
