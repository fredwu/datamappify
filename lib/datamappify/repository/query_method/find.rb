module Datamappify
  module Repository
    module QueryMethod
      class Find < Method
        # @param repository (see Method#initialize)
        #
        # @param id_or_ids [Integer, Array<Integer>]
        #   an entity id or a collection of entity ids
        def initialize(repository, id_or_ids)
          super
          @id_or_ids = id_or_ids
        end

        # @return [Entity, Array<Entity>, nil]
        def perform
          entities = Array.wrap(@id_or_ids).map { |id| setup_new_entity(id) }.compact

          @id_or_ids.is_a?(Array) ? entities : entities[0]
        end

        private

        # @param id [Integer]
        #
        # @return [Entity, nil]
        def setup_new_entity(id)
          entity = mapper.entity_class.new
          entity.id = id

          if dispatch_criteria_to_default_source(:Exists, entity)
            dispatch_criteria_to_providers(:FindByKey, entity)
          else
            entity = nil
          end

          entity
        end
      end
    end
  end
end
