require 'datamappify/data/criteria/relational/find'
require 'datamappify/data/criteria/relational/concerns/set_criteria'

module Datamappify
  module Data
    module Criteria
      module Relational
        class FindByKey < Find
          include Concerns::SetCriteria

          def initialize(source_class, entity, attributes, options = {}, &block)
            super(source_class, entity, nil, attributes, options, &block)
          end

          private

          def criteria_for_reverse_mapping
            reverse_id = options[:primary_record].send(options[:via])
            reverse_id ? { :id => reverse_id } : {}
          end
        end
      end
    end
  end
end
