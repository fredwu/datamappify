module Datamappify
  module Repository
    module QueryMethod
      class Criteria < Method
        # @return [Array<Entity>]
        def perform
          dispatch_criteria_to_default_source(:Criteria, @entity)
        end

        # @see Method#reader?
        def reader?
          true
        end
      end
    end
  end
end
