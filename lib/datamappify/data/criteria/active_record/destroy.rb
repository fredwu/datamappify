module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Destroy < Common
          def initialize(source_class, id)
            super(source_class, nil, id)
          end

          def perform
            source_class.destroy(criteria)
          end
        end
      end
    end
  end
end
