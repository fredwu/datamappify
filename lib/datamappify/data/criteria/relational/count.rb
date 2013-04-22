module Datamappify
  module Data
    module Criteria
      module Relational
        class Count < Common
          def perform
            source_class.count
          end
        end
      end
    end
  end
end
