require 'datamappify/data/criteria/relational/criteria'

module Datamappify
  module Data
    module Criteria
      module Relational
        class Count < Criteria
          def perform
            (records || source_class).count
          end
        end
      end
    end
  end
end
