module Datamappify
  module Repository
    class AttributeSourceDataClassBuilder
      class << self
        def build(data_class_name, data_fields_mapping)
          @data_class_name = data_class_name

          build_data_class unless data_class_is_defined?
        end

        private

        def build_data_class
          Data.const_set(@data_class_name, Class.new(Data::Base))
        end

        def data_class_is_defined?
          Data.const_defined?(@data_class_name, false)
        end
      end
    end
  end
end
