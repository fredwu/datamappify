Dir[Datamappify.root.join("data/criteria/relational/*.rb")].each { |file| require file }

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
                class #{source_class_name} < ::Sequel::Model(:#{scoped_tableize(source_class_name)})
                  raise_on_save_failure = true
                  unrestrict_primary_key
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
              one_to_one :#{attribute.association_key},
                         :class => :"#{attribute.source_class.name}",
                         :key   => :#{attribute.reference_key}
            CODE
          end

          # @return [void]
          def build_record_reversed_association(attribute, default_source_class)
            default_source_class.class_eval <<-CODE, __FILE__, __LINE__ + 1
              many_to_one :#{attribute.association_key},
                          :class => :"#{attribute.source_class.name}",
                          :key   => :#{attribute.options[:via]}
            CODE
          end

          def provider_name
            'Sequel'
          end
        end
      end
    end
  end
end
