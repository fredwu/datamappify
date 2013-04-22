module Datamappify
  module Data
    module Criteria
      module Sequel
        class Exists < Common
          def perform
            source_class.where(:id => entity.id).any?
          end
        end
      end
    end
  end
end
