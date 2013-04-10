module Datamappify
  module Data
    module Criteria
      module Sequel
        class Transaction < Common
          def result
            source_class.db.transaction(&@block)
          end
        end
      end
    end
  end
end
