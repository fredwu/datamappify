module Datamappify
  module Repository
    module QueryMethod
      class Count
        def initialize(mapper)
          @mapper = mapper
        end

        def result
          @mapper.default_provider.build_criteria(:Count, @mapper.default_source_class)
        end
      end
    end
  end
end
