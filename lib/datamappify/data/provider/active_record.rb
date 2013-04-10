Dir[Datamappify.root.join("data/criteria/relational/*.rb")].each { |file| require file }

module Datamappify
  module Data
    module Provider
      module ActiveRecord
        extend CommonProvider

        def self.build_record(source_class_name)
          Datamappify::Data::Record::ActiveRecord.const_set(
            source_class_name, Class.new(::ActiveRecord::Base)
          )
        end
      end
    end
  end
end
