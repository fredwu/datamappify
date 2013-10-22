module Datamappify
  module Repository
    module QueryMethod
      class Count < Method
        # @return [Integer]
        def perform
          dispatch_criteria_to_default_source(
            :Count, data_mapper.entity_class, criteria, data_mapper.attributes
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
