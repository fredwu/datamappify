module Datamappify
  module Repository
    module QueryMethod
      class Count
        # @param mapper [Data::Mapper]
        def initialize(mapper)
          @mapper = mapper
        end

        # @return [Integer]
        def result
          @mapper.default_provider.build_criteria(:Count, @mapper.default_source_class)
        end
      end
    end
  end
end
