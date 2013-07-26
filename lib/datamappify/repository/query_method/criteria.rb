module Datamappify
  module Repository
    module QueryMethod
      class Criteria < Method
        # @return [Array<Entity>]
        def perform
          dispatch_criteria_to_default_source(
            :Criteria, data_mapper.entity_class, criteria, data_mapper.attributes
          )
        end

        # @see Method#reader?
        def reader?
          true
        end
      end
    end
  end
end
