module Datamappify
  module Repository
    module QueryMethod
      class Destroy < Method
        # @param options (see Method#initialize)
        #
        # @param id_or_entity [Entity]
        #   an entity or a collection of ids or entities
        def initialize(options, id_or_entity)
          super
          @id_or_entity = id_or_entity
        end

        # @return [void, false]
        def perform
          dispatch_criteria_to_default_source(:Destroy, extract_entity_id(@id_or_entity))
        end

        # @see Method#writer?
        def writer?
          true
        end
      end
    end
  end
end
