module Datamappify
  module Data
    module Criteria
      module Sequel
        class FindByKey < Find
          def initialize(source_class, entity, attributes, &block)
            super(source_class, entity, nil, attributes, &block)

            @criteria = { key_name => entity.id }
          end
        end
      end
    end
  end
end
