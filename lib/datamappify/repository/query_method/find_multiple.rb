module Datamappify
  module Repository
    module QueryMethod
      class FindMultiple < Method
        # @param options (see Method#initialize)
        #
        # @param where [Hash]
        #   a hash containing all the find criterias
        def initialize(options, criteria)
          super
          @criteria = criteria
        end

        # @return [Array<Entity>]
        def perform
          dispatch_criteria_to_default_source(
            :FindMultiple, data_mapper.entity_class, @criteria, data_mapper.attributes
          )
        end

        # @see Method#reader?
        def reader?
          true
        end
      end
    end
  end
end
