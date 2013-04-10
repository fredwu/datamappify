module Datamappify
  module Repository
    module QueryMethod
      class Transaction
        def initialize(mapper, &block)
          mapper.default_provider.build_criteria(:Transaction, mapper.default_source_class, &block)
        end
      end
    end
  end
end

