module Datamappify
  module Repository
    class Collection < Array
      if defined?(::Kaminari)
        require 'datamappify/extensions/kaminari/collection_methods'
        include Extensions::Kaminari::CollectionMethods
      end

      def map(*args, &block)
        self.class.new(super)
      end
    end
  end
end
