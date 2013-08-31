module Datamappify
  module Repository
    module QueryMethod
      class WhereOrMatch < Method
        # @return [Array<Entity>]
        def perform
          results = dispatch_criteria_to_default_source(
            self.class.name.demodulize.to_sym, data_mapper.entity_class, criteria, data_mapper.attributes
          )

          MultiResultBlender.new(self).blend(results)
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
