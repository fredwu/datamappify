module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Limit < Common
          def records(scope = nil)
            limit, offset = criteria
            offset ||= 0

            (scope || source_class).limit(limit).offset(offset)
          end
        end
      end
    end
  end
end
