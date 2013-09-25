require 'observer'
require 'virtus'
require 'datamappify/entity/compatibility/active_model'
require 'datamappify/entity/compatibility/active_record'
require 'datamappify/entity/lazy_checking'
require 'datamappify/entity/composable'
require 'datamappify/entity/association'
require 'datamappify/entity/inspectable'

module Datamappify
  module Entity
    def self.included(klass)
      klass.class_eval do
        include Observable
        include Virtus.model
        include Equalizer.new(*klass.attribute_set)
        include ::ActiveModel::Model
        include Compatibility::ActiveModel
        include Compatibility::ActiveRecord
        include LazyChecking
        include Composable
        include Association
        include Inspectable

        attribute :id, Integer
      end
    end
  end
end
