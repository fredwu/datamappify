module Datamappify
  module Fake
    class Column < ActiveRecord::ConnectionAdapters::Column
      def initialize(property)
        allow_null = property[:options].include?(:null) ? property[:options][:null] : true
        
        super(property[:name], property[:options][:default], property[:sql_type], allow_null)
        
        @limit     = property[:options][:limit]
        @precision = property[:options][:precision]
        @scale     = property[:options][:scale]
      end
    end
  end
end