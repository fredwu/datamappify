module Datamappify
  module Repository
    module QueryMethod
      class Find < Method
        # @return [Entity, nil]
        def perform
          entity = data_mapper.entity_class.new
          entity.id = criteria

          if dispatch_criteria_to_default_source(:Exists, entity)
            dispatch_criteria_to_providers(:FindByKey, entity)
          else
            entity = nil
          end

          entity
        end

        # @see Method#reader?
        def reader?
          true
        end
      end
    end
  end
end
