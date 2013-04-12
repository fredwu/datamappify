module Datamappify
  module Repository
    module QueryMethod
      module Helper
        private

        # Dispatches a {Criteria} via {#attributes_walker}
        #
        # @param entity [Entity]
        # @return [void]
        def dispatch_criteria_to_providers(entity, criteria_name)
          attributes_walker do |provider_name, source_class, attributes|
            @mapper.provider(provider_name).build_criteria(
              criteria_name, source_class, entity, attributes
            )
          end
        end

        # Walks through the attributes and performs actions on them
        #
        # @yield [provider_name, source_class, attributes] action to be performed
        #   on the attributes grouped by their source class
        # @yieldparam provider_name [String]
        # @yieldparam source_class [Class]
        # @yieldparam attributes [Set]
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
        # @return [Integer]
        def extract_entity_id(id_or_entity)
          id_or_entity.is_a?(Integer) ? id_or_entity : id_or_entity.id
        end
      end
    end
  end
end
