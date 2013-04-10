module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class SaveByKey < Save
          def initialize(source_class, entity, attributes, &block)
            super(source_class, entity, {}, attributes, &block)

            @criteria = { key_name => entity.id } unless entity.id.nil?
          end
        end
      end
    end
  end
end
