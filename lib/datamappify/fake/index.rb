require 'active_record/connection_adapters/abstract/schema_statements'

module Datamappify
  module Fake
    class Index
      include ActiveRecord::ConnectionAdapters::SchemaStatements
      
      def initialize(resource, index)
        @resource = resource
        @index    = index
      end
      
      def table
        @resource[:table_name]
      end
      
      def name
        @index[:options].include?(:name) ? @index[:options][:name].to_s : index_name(table, :column => @index[:columns])
      end
      
      def columns
        @index[:columns]
      end
      
      def unique
        @index[:options][:unique] if @index[:options].include?(:unique)
      end
      
      def lengths
        @index[:options][:length] if @index[:options].include?(:length)
      end
    end
  end
end