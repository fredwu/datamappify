Dir[Datamappify.root.join("data/criteria/relational/*.rb")].each { |file| require file }

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
            class_eval <<-CODE, __FILE__, __LINE__ + 1
              module Datamappify::Data::Record::ActiveRecord
                class #{source_class_name} < ::ActiveRecord::Base
                  self.table_name = '#{source_class_name.pluralize.gsub('::', '_').underscore}'
                end
              end
            CODE

            "Datamappify::Data::Record::ActiveRecord::#{source_class_name}".constantize
          end

          # @return [void]
          def build_record_association(attribute, default_source_class)
            default_source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              has_one :#{attribute.association_key},
                      :class_name  => :"#{attribute.source_class.name}",
                      :foreign_key => :#{attribute.reference_key}
            CODE
          end

          # @return [void]
          def build_record_reversed_association(attribute, default_source_class)
            default_source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              belongs_to :#{attribute.association_key},
                         :class_name  => :"#{attribute.source_class.name}",
                         :foreign_key => :#{attribute.options[:via]}
            CODE
          end
        end
      end
    end
  end
end
