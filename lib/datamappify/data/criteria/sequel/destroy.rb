module Datamappify
  module Data
    module Criteria
      module Sequel
        class Destroy < Common
          def initialize(source_class, id)
            super(source_class, nil, id)
          end

          def result
            source_class.where(:id => criteria).destroy
          end
        end
      end
    end
  end
end
