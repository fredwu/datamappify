module Datamappify
  module Repository
    module Inheritable
      # @param klass [Repository]
      #
      # @return [void]
      def inherited(klass)
        klass.class_eval { include Repository }

        setup_data_mapper(klass)

        klass.data_mapper.default_source_class
      end

      private

      # @param klass (see #inherited)
      #
      # @return [void]
      def setup_data_mapper(klass)
        klass.for_entity       self.data_mapper.entity_class
        klass.default_provider self.data_mapper.default_provider_name

        klass.data_mapper.custom_mapping = self.data_mapper.custom_mapping.dup
      end
    end
  end
end
