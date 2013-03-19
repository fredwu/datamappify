module Datamappify
  module Repository
    class AttributeSourceDataClassBuilder
      def initialize(provider_class_name, data_class_name)
        @provider_class_name = provider_class_name
        @data_class_name     = data_class_name
      end

      def build(data_fields_mapping)
        require "datamappify/data/provider/#{@provider_class_name.underscore}"

        unless data_class_is_defined?
          provider_module.build_data_class(@data_class_name)
        end
      end

      private

      def provider_module
        @provider_module ||= "Datamappify::Data::Provider::#{@provider_class_name}".constantize
      end

      def data_class_is_defined?
        provider_module.const_defined?(@data_class_name, false)
      end
    end
  end
end
