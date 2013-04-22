module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Transaction < Common
          def perform
            source_class.transaction(&@block)
          end
        end
      end
    end
  end
end
