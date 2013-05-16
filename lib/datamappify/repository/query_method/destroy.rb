module Datamappify
  module Repository
    module QueryMethod
      class Destroy < Method
        # @param options (see Method#initialize)
        #
        # @param entity [Entity]
        def initialize(options, entity)
          super
          @entity = entity
        end

        # @return [void, false]
        def perform
          dispatch_criteria_to_default_source(:Destroy, @entity.id)
        end

        # @see Method#writer?
        def writer?
          true
        end
      end
    end
  end
end
