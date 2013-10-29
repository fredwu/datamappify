require 'datamappify/data/provider/common_provider'

module Datamappify
  module Data
    module Provider
      extend ActiveSupport::Autoload

      autoload :ActiveRecord
      autoload :Sequel

      # Like the ActiveSupport.tableize inflector, but correctly
      # converts class namespaces to valid table names.
      #
      # AS.tableize      'Foo::Fighter' => "foo/fighters"
      # scoped_tableize  'Foo::Fighter' => "foo_fighters"
      #
      # @return [String]
      def self.scoped_tableize(class_name)
        class_name.gsub('::', '_').tableize
      end
    end
  end
end
