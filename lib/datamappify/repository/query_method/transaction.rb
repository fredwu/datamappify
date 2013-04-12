module Datamappify
  module Repository
    module QueryMethod
      class Transaction < Method
        # @param mapper (see Method#initialize)
        # @yield queries to be performed in the transaction
        # @return [void]
        def initialize(mapper, &block)
          mapper.default_provider.build_criteria(:Transaction, mapper.default_source_class, &block)
        end
      end
    end
  end
end

