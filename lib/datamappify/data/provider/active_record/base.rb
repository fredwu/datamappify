module Datamappify
  module Data
    module ActiveRecord
      class Base < ::ActiveRecord::Base
        self.abstract_class = true
      end
    end
  end
end
