module Datamappify
  module Repository
    module QueryMethod
      class Count < Method
        # @param mapper [Data::Mapper]
        def initialize(mapper)
          @mapper = mapper
        end

        # @return [Integer]
        def result
          dispatch_criteria_to_default_source(:Count)
        end
      end
    end
  end
end
