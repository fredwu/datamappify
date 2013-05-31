module Datamappify
  module Data
    module Provider
      module Sequel
        extend CommonProvider

        class << self
          # @return [Sequel::Model]
          def build_record_class(source_class_name)
            Record::Sequel.const_set(
              source_class_name, Class.new(::Sequel::Model(source_class_name.pluralize.underscore.to_sym))
            ).tap do |klass|
              klass.raise_on_save_failure = true
            end
          end

          # @return [void]
          def build_record_association(attribute, default_source_class)
            default_source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              one_to_one :#{attribute.source_key}
            CODE

            attribute.source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              one_to_one :#{default_source_class.table_name.to_s.singularize}
            CODE
          end
        end
      end
    end
  end
end
