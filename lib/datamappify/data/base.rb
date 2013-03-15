module Datamappify
  module Data
    class Base < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
