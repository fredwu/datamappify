module Datamappify
  module Data
    module Criteria
      module Relational
        class Limit < Common
          def records(scope)
            scope.limit(criteria)
          end
        end
      end
    end
  end
end
