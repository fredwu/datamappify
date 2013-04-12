module Datamappify
  module Data
    module Provider
      module Sequel
        extend CommonProvider

        # @return [Sequel::Model]
        def self.build_record_class(source_class_name)
          Record::Sequel.const_set(
            source_class_name, Class.new(::Sequel::Model(source_class_name.pluralize.underscore.to_sym))
          ).tap do |klass|
            klass.raise_on_save_failure = true
          end
        end
      end
    end
  end
end
