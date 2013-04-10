module Datamappify
  module Data
    module Criteria
      module Sequel
        class Count < Common
          def result
            source_class.count
          end
        end
      end
    end
  end
end
