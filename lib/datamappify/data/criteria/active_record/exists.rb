module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Exists < Common
          def result
            source_class.exists?(entity.id)
          end
        end
      end
    end
  end
end
