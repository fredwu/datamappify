module Datamappify
  module Data
    module Provider
      module ActiveRecord
        extend CommonProvider

        class << self
          # @param source_class_name (see CommonProvider::ModuleMethods#find_or_build_record_class)
          #
          # @return [ActiveRecord::Base]
          def build_record_class(source_class_name)
            Datamappify::Data::Record::ActiveRecord.const_set(
              source_class_name, Class.new(::ActiveRecord::Base)
            )
          end

          # @return [void]
          def build_record_association(attribute, default_source_class)
            default_source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              has_one :#{attribute.source_key}
            CODE

            attribute.source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              belongs_to :#{default_source_class.model_name.element}
            CODE
          end

          # @return [void]
          def build_record_reversed_association(attribute, default_source_class)
            default_source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              belongs_to :#{attribute.source_key}
            CODE
          end
        end
      end
    end
  end
end
