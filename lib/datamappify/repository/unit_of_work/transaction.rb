module Datamappify
  module Repository
    module UnitOfWork
      class Transaction
        # @param data_mapper (see QueryMethod::Method#initialize)
        #
        # @yield
        #   queries to be performed in the transaction
        #
        # @return [void]
        def initialize(data_mapper, &block)
          data_mapper.default_provider.build_criteria(:Transaction, data_mapper.default_source_class, &block)
        end
      end
    end
  end
end

