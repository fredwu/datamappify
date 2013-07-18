require 'datamappify/data/criteria/relational/concerns/set_criteria'

module Datamappify
  module Data
    module Criteria
      module Relational
        module SaveByKey
          include Concerns::SetCriteria

          def initialize(source_class, entity, attributes, options = {}, &block)
            super(source_class, entity, {}, attributes, options, &block)
          end

          private

          def criteria_for_reverse_mapping
            {}
          end
        end
      end
    end
  end
end
