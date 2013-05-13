require 'datamappify/repository/unit_of_work/persistent_states/object'

module Datamappify
  module Repository
    module UnitOfWork
      # Tracks dirty entity attributes
      class PersistentStates
        def initialize
          @pool = {}
        end

        # Finds or attaches an entity
        #
        # @param entity [Entity]
        #
        # @return [Entity]
        def find(entity)
          @pool.has_key?(entity.object_id) ? refresh(entity) : attach(entity)
        end

        # Refreshes the states stored for an entity
        #
        # @param entity [Entity]
        #
        # @return [Entity]
        def refresh(entity)
          @pool[entity.object_id].tap { |o| o.update_values(entity) }
        end

        # Attaches an entity
        #
        # @param entity [Entity]
        #
        # @return [Entity]
        def attach(entity)
          @pool[entity.object_id] = Object.new(entity)
        end

        # Executes a block then reattaches the entity
        #
        # @param entity [Entity]
        #
        # @return [Entity]
        def update(entity, &block)
          find(entity)

          block.call

          attach(entity)
        end
      end
    end
  end
end
