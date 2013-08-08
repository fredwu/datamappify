module Datamappify
  module Repository
    module QueryMethod
      class Match < Method
        # @return [Array<Entity>]
        def perform
          results = dispatch_criteria_to_default_source(
            :Match, data_mapper.entity_class, criteria, data_mapper.attributes
          )

          results.each do |entity|
            states.find(entity)
          end

          results
        end

        # @see Method#reader?
        def reader?
          true
        end
      end
    end
  end
end
