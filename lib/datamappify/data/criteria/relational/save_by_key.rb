require 'datamappify/data/criteria/relational/concerns/set_criteria'

module Datamappify
  module Data
    module Criteria
      module Relational
        module SaveByKey
          include Concerns::SetCriteria

          EMPTY_CRITERIA = {}.freeze

          def initialize(source_class, entity, attributes, options = {}, &block)
            super(source_class, entity, EMPTY_CRITERIA, attributes, options, &block)
          end
        end
      end
    end
  end
end
