module Datamappify
  module Entity
    class AssociatedCollection
      def initialize(context, name)
        build_collection_getter(context, name)
        build_collection_setter(context, name)
      end

      private

      def build_collection_getter(context, name)
        context.class_eval <<-CODE
          def #{name}
            @#{name} ||= []
          end
        CODE
      end

      def build_collection_setter(context, name)
        context.class_eval <<-CODE
          def #{name}=(collection)
            @#{name} = collection
          end
        CODE
      end
    end
  end
end
