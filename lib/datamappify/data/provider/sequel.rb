module Datamappify
  module Data
    module Provider
      module Sequel
        extend CommonProvider

        def self.build_record(source_class_name)
          Datamappify::Data::Record::Sequel.const_set(
            source_class_name, Class.new(::Sequel::Model(source_class_name.pluralize.underscore.to_sym))
          ).tap do |klass|
            klass.raise_on_save_failure = true
          end
        end
      end
    end
  end
end
