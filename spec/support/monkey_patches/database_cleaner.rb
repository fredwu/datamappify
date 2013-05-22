# @see https://github.com/bmabey/database_cleaner/pull/211
module DatabaseCleaner
  module Sequel
    class Truncation
      def each_table
        tables_to_truncate(db).each do |table|
          yield db, table.to_sym
        end
      end
    end
  end
end
