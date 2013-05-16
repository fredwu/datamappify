module Datamappify
  module Repository
    module QueryMethod
      class Exists < Method
        # @param options (see Method#initialize)
        #
        # @param entity [Entity]
        def initialize(options, entity)
          super
          @entity = entity
        end

        # @return [Boolean]
        def perform
          dispatch_criteria_to_default_source(:Exists, @entity)
        end

        # @see Method#reader?
        def reader?
          true
        end
      end
    end
  end
end
