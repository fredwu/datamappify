require 'datamappify/data/association_methods'

module Datamappify
  module Data
    class Base < ActiveRecord::Base
      extend Data::AssociationMethods

      self.abstract_class = true
    end
  end
end
