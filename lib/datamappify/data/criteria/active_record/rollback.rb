module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Rollback < Common
          def perform
            raise ::ActiveRecord::Rollback
          end
        end
      end
    end
  end
end
