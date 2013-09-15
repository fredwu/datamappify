require 'datamappify/data/criteria/relational/concerns/set_criteria'

module Datamappify
  module Data
    module Criteria
      module Relational
        module Concerns
          module FindByKey
            include SetCriteria

            def initialize(source_class, entity, attributes, options = {}, &block)
              super(source_class, entity, nil, attributes, options, &block)
            end
          end
        end
      end
    end
  end
end
