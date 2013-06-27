module Datamappify
  module Data
    module Provider
      module Sequel
        extend CommonProvider

        class << self
          # @param source_class_name (see CommonProvider::ModuleMethods#find_or_build_record_class)
          #
          # @return [Sequel::Model]
          def build_record_class(source_class_name)
            class_eval <<-CODE, __FILE__, __LINE__ + 1
              module Datamappify::Data::Record::Sequel
                class #{source_class_name} < ::Sequel::Model(:#{source_class_name.pluralize.gsub('::', '_').underscore})
                  raise_on_save_failure = true
                end
              end
            CODE

            "Datamappify::Data::Record::Sequel::#{source_class_name}".constantize
          end

          # @param attribute (see Record#build_association)
          #
          # @param default_source_class (see Record#build_association)
          #
          # @return [void]
          def build_record_association(attribute, default_source_class)
            default_source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              one_to_one :#{attribute.source_key}
            CODE

            attribute.source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              many_to_one :#{default_source_class.table_name.to_s.singularize}
            CODE
          end

          # @return [void]
          def build_record_reversed_association(attribute, default_source_class)
            default_source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              many_to_one :#{attribute.source_key}
            CODE
          end
        end
      end
    end
  end
end
