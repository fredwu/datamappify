module Datamappify
  module Repository
    module DSL
      def for_entity(entity_class)
        self.entity_class = entity_class
      end
    end
  end
end
