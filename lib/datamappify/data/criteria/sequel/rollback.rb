module Datamappify
  module Data
    module Criteria
      module Sequel
        class Rollback < Common
          def perform
            raise ::Sequel::Rollback
          end
        end
      end
    end
  end
end
