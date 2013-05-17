module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Exists < Common
          def perform
            !!source_class.exists?(entity.id)
          end
        end
      end
    end
  end
end
