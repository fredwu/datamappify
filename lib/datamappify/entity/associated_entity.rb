module Datamappify
  module Entity
    class AssociatedEntity
      def initialize(context, name)
        build_entity_getter(context, name)
        build_entity_setter(context, name)
      end

      private

      def build_entity_getter(context, name)
        context.class_eval <<-CODE
          def #{name}
            @#{name} ||= "#{name}".classify.constantize.new
          end
        CODE
      end

      def build_entity_setter(context, name)
        context.class_eval <<-CODE
          def #{name}=(entity)
            @#{name} = entity
          end
        CODE
      end
    end
  end
end
