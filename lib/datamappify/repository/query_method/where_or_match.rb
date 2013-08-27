module Datamappify
  module Repository
    module QueryMethod
      class WhereOrMatch < Method
        # @return [Array<Entity>]
        def perform
          results = dispatch_criteria_to_default_source(
            self.class.name.demodulize, data_mapper.entity_class, criteria, data_mapper.attributes
          )

          results.each do |entity|
            states.find(entity)
            walk_references(:Find, entity)
          end

          results
        end

        # @see Method#reader?
        def reader?
          true
        end
      end

      class Where < WhereOrMatch; end
      class Match < WhereOrMatch; end
    end
  end
end
