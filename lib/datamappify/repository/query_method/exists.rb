module Datamappify
  module Repository
    module QueryMethod
      class Exists < Method
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
